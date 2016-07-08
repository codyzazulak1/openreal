class AddWishlistToFavorites < ActiveRecord::Migration
  def up

    add_reference :favorites, :wishlist, index: true
    add_foreign_key :favorites, :wishlists

  end
  def down

    remove_reference :favorites, :wishlist
    remove_foreign_key :favorites, :wishlists

  end
end
