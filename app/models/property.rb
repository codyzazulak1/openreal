class Property < ActiveRecord::Base

  has_one :address, :dependent => :destroy
  has_many :photos

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :photos

end
