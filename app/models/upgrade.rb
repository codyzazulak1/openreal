class Upgrade < ActiveRecord::Base

  has_many :property_upgrades
  has_many :properties, :through => :property_upgrades

end
