class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :repository_id, type: String
  field :name, type: String
  field :formatted_name, type: String
  field :display_pos, type: Integer
  field :repo_url, type: String
  field :site_url, type: String
  field :description, type: String
  embeds_many :languages, inverse_of: :project
  embeds_many :images, inverse_of: :project
  embedded_in :user, inverse_of: :projects

  validates :repository_id, :name, :repo_url, presence: true
  validate :ensure_formatted_name
  validate :ensure_site_url
  validate :ensure_display_pos

  def ensure_formatted_name
    self.formatted_name = name.gsub(/(-|_)/, " ").split.map(&:capitalize).join(" ")
  end

  def ensure_site_url
    self.site_url = nil if site_url == ""
  end

  def ensure_display_pos
    self.display_pos = 0 unless display_pos
  end
end