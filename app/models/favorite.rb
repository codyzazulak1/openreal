class Favorite < ActiveRecord::Base

  validates :property_id, :uniqueness => {:scope => :customer_id}

  belongs_to :property
  belongs_to :customer

end
