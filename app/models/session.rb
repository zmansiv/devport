class Session
  include Mongoid::Document

  field :token, type: String
  field :ip, type: String
  field :user_agent, type: String

  embedded_in :user, inverse_of: :sessions

  before_validation :ensure_token
  validates :token, presence: true
  validates :token, uniqueness: { case_sensitive: false }

  def ensure_token
    self.token ||= self.class.generate_token
  end

  def self.generate_token
    SecureRandom::urlsafe_base64(16)
  end
end