class Property < ActiveRecord::Base

  has_one :address, :dependent => :destroy

  accepts_nested_attributes_for :address

  mount_uploader :photo, PhotoUploader

end
