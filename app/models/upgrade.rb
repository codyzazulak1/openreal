class Upgrade < ActiveRecord::Base

	has_many :properties_upgrades
	has_many :properties, through: :properties_upgrades

	accepts_nested_attributes_for :properties_upgrades

	def upgrade_items(property)
		property.upgrades.each do |d|
		 	d
	end
		
	end
end
