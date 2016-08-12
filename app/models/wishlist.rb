class Wishlist < ActiveRecord::Base

  belongs_to :customer
  has_many :favorites

end
