class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :github_token, type: String
  field :linkedin_token, type: String
  field :linkedin_secret, type: String
  field :name, type: String
  field :email, type: String
  field :gravatar_id, type: String
  field :location, type: String
  field :bio, type: String
  field :twitter_id, type: String
  field :github_id, type: String
  field :linkedin_id, type: String
  field :blog_url, type: String
  field :skills, type: Array
  embeds_many :jobs, inverse_of: :user
  embeds_many :projects, inverse_of: :user

  has_many :sessions

  index github_id: 1
  index name: 1

  validates :github_token, presence: true
  validates :github_id, uniqueness: { case_sensitive: false }

  def self.find_or_create_from_github(auth_data)
    token = auth_data["credentials"]["token"]
    info = auth_data["extra"]["raw_info"]
    user = User.find_by github_id: info["login"]
    unless user
      user = User.create github_token: token
      user.sync_github_data info
    end
    user
  end

  def sync_github_data(info = nil)
    github = Github.new oauth_token: github_token
    unless info
      info = github.users.get
    end
    parse_info(
      info,
      true,
      :name,
      :email,
      :gravatar_id,
      :location,
      :bio,
      {
        login: :github_id,
        blog: :blog_url
      }
    )
    parse_info_array(
        github.repos.list(user: github_id),
        "projects"
    ) do |repo|
      proj = self.projects.new(
          repository_id: repo.id,
          name: repo.name,
          repo_url: repo.html_url,
          site_url: repo.homepage,
          description: repo.description
      )
      github.repos.languages(github_id, repo.name).each do |lang|
        proj.languages.new(name: lang[0], bytes: lang[1])
      end
      proj
    end
    save
  end

  def sync_linkedin_data
    linkedin = LinkedIn::Client.new(ENV["linkedin_key"], ENV["linkedin_secret"])
    linkedin.authorize_from_access(linkedin_token, linkedin_secret)
    info = linkedin.profile(fields: ENV["linkedin_fields"].split)
    parse_info(
        info,
        false,
        {
          id: :linkedin_id,
          "location.name" => :location,
          summary: :bio,
          email_address: :email
        }
    )
    parse_info_array(
        info.skills.all,
        "skills",
        "skill.name"
    )
    parse_info_array(
        info.positions.all,
        "jobs"
    ) do |info_el|
      self.jobs.new(
          title: info_el.title,
          company: info_el.company.name,
          description: info_el.summary,
          start_date: "#{info_el.start_date.month} #{info_el.start_date.year}",
          end_date: info_el.end_date ? "#{info_el.end_date.month} #{info_el.end_date.year}" : nil
      )
    end
    save
  end

  def parse_info_array(info, model_field, info_field = nil)
    val = info.map do |info_element|
      if block_given?
        yield info_element
      else
        get_field(info_element, info_field)
      end
    end

    self.send("#{model_field}=", val)
  end

  def parse_info(info, overwrite, *attrs)
    attrs.each do |attr|
      if attr.is_a? Hash
        attr.each do |info_field, model_field|
          set_attr(info, overwrite, info_field, model_field)
        end
      else
        set_attr(info, overwrite, attr, attr)
      end
    end
  end

  def set_attr(info, overwrite, info_field, model_field)
    info_field = info_field.to_s.gsub("-", "_")
    model_field = model_field.to_s.gsub("-", "_")
    old_val = self.send(model_field)
    new_val = get_field(info, info_field)
    if overwrite || !old_val
      if new_val
        self.send("#{model_field}=", new_val)
      end
    end
  end

  def get_field(obj, field)
    if field.include?(".")
      fields = field.split(".")
      outer = obj.send(fields[0])
      outer.send(fields[1])
    else
      obj.send(field)
    end
  end
end
