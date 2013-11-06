class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :github_token, type: String
  field :linkedin_token, type: String
  field :linkedin_secret, type: String
  field :name, type: String
  field :email, type: String
  field :avatar_url, type: String
  field :location, type: String
  field :age, type: Integer
  field :bio, type: String
  field :twitter_id, type: String
  field :github_id, type: String
  field :linkedin_id, type: String
  field :blog_url, type: String
  embeds_one :technologies
  embeds_many :projects

  has_many :sessions

  index github_id: 1

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
    unless info
      github = Github.new oauth_token: github_token
      info = github.users.get
    end
    parse_info info, :name, :email, :avatar_url, :location, :bio, {login: :github_id, blog: :blog_url}
    save
  end

  def sync_linkedin_data
    linkedin = LinkedIn::Client.new(ENV["linkedin_key"], ENV["linkedin_secret"])
    linkedin.authorize_from_access(linkedin_token, linkedin_secret)
    fields = %w(id location:(name) summary email-address)
    info = linkedin.profile(fields: fields)
    parse_info info, {id: :linkedin_id, "location.name" => location, bio: :summary, email: :email_address}
    save
  end

  def parse_info(info, *attrs)
    attrs.each do |attr|
      if attr.is_a? Hash
        attr.each do |info_field, model_field|
          set_attr(info, info_field, model_field)
        end
      else
        set_attr(info, attr, attr)
      end
    end
  end

  def set_attr(info, info_field, model_field)
    info_field = info_field.to_s.gsub("-", "_")
    model_field = model_field.to_s.gsub("-", "_")
    val = info.send(info_field)
    self.send("#{model_field}=", val) if val
  end
end
