class Property < ActiveRecord::Base

  has_one :address, :dependent => :destroy
  has_many :photos
  has_many :favorites

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :photos

  def has_photos?
    return true if self.photos.count > 0
    return false
  end

  def lot_area
    return self.lot_length * self.lot_width
  end

end
