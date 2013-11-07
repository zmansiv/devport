class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :company, type: String
  field :description, type: String
  field :start_date, type: String
  field :end_date, type: String

  embedded_in :user, inverse_of: :jobs

  validates :title, :company, :start_date, presence: true
end