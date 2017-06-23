class Photo < ActiveRecord::Base

  mount_uploader :picture, PictureUploader
  process_in_background :picture
  
  belongs_to :property

end
