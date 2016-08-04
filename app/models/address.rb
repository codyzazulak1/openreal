class Address < ActiveRecord::Base

  validates :address_first, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  belongs_to :property

end
