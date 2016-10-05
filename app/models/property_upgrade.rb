class PropertyUpgrade < ActiveRecord::Base

  belongs_to :property
  belongs_to :upgrade

  accepts_nested_attributes_for :upgrade
end
