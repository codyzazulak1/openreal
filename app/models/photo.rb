class Photo < ActiveRecord::Base

  mount_uploader :picture, PictureUploader

  belongs_to :property
  belongs_to :agent

end
