class PropertyUpgrade < ActiveRecord::Base

  belongs_to :property
  belongs_to :upgrade

end
