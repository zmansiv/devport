class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :repository_id, type: String
  field :name, type: String
  field :formatted_name, type: String
  field :url, type: String
  field :description, type: String
  field :skills, type: Array
  field :screenshots, type: Array

  embedded_in :user, inverse_of: :projects

  validates :repository_id, :name, :url, presence: true
  validate :ensure_formatted_name

  def ensure_formatted_name
    self.formatted_name = name.gsub("-", " ").split.map(&:capitalize).join(" ")
  end
end