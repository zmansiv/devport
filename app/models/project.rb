class Project
  include Mongoid::Document

  field :repository_id, type: String
  field :name, type: String
  field :url, type: String
  field :description, type: String
  field :screenshots, type: Array
  field :technologies, type: Array

  embedded_in :user, inverse_of: :projects

  validates :repository_id, presence: true
end