class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :github_token, type: String
  field :linkedin_token, type: String
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

  def sync_github_data(info)
    unless info
      github = Github.new oauth_token: github_token
      info = github.users.get
    end
    parse_info info, :name, :email, :avatar_url, :location, :bio, {login: :github_id, blog: :blog_url}
    save
  end

  def parse_info(info, *fields)
    fields.each do |field|
      if field.is_a? Hash
        field.each do |info_field, model_field|
          self.send "#{model_field}=", info.send(info_field)
        end
      else
        self.send "#{field}=", info.send(field)
      end
    end
  end
end
