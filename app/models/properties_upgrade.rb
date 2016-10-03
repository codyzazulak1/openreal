class PropertiesUpgrade < ActiveRecord::Base
	belongs_to :property
	belongs_to :upgrade

	accepts_nested_attributes_for :property
end