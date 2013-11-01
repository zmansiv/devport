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

  validates :github_token, :name, :github_id, presence: true
  validates :github_id, uniqueness: { case_sensitive: false }
end
