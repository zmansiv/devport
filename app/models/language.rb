class Language
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :bytes, type: Integer
  embedded_in :project, inverse_of: :languages

  validates :name, :bytes, presence: true
end