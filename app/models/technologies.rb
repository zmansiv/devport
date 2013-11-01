class Technologies
  include Mongoid::Document

  field :languages, type: Array
  field :frameworks, type: Array
  field :databases, type: Array
  field :version_control_systems, type: Array

  embedded_in :user, inverse_of: :technologies
end