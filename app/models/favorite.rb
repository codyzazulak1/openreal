class Favorite < ActiveRecord::Base

  belongs_to :wishlist

  has_one :property

end
