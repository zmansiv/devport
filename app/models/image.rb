class Image
  include Mongoid::Document

  embedded_in :project, inverse_of: :images

  #mount_uploader :image, ImageUploader
end