class Property < ActiveRecord::Base

  belongs_to :favorite
  has_one :address, :dependent => :destroy
  has_many :photos

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :photos

  def has_photos?
    return true if self.photos.count > 0
    return false
  end

end
