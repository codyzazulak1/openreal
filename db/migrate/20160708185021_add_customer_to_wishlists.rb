class AddCustomerToWishlists < ActiveRecord::Migration
  def up
    add_reference :wishlists, :customer, index: true
    add_foreign_key :wishlists, :customers
  end

  def down
    remove_reference :wishlists, :customer
    remove_foreign_key :wishlists, :customers
  end
end
