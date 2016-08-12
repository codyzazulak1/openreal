class AddWishlistKeys < ActiveRecord::Migration
  def change
    add_reference :wishlists, :customer, foreign_key: true
    add_reference :favorites, :wishlist, foreign_key: true
  end
end
