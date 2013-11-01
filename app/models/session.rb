class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :ip, type: String
  field :user_agent, type: String

  belongs_to :user, inverse_of: :sessions

  index token: 1

  before_validation :ensure_token
  validates :token, presence: true
  validates :token, uniqueness: { case_sensitive: false }

  def ensure_token
    self.token ||= self.class.generate_token
  end

  def self.generate_token
    SecureRandom::urlsafe_base64 16
  end
end