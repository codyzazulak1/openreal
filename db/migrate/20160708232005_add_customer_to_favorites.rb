class AddCustomerToFavorites < ActiveRecord::Migration

  def up
    add_reference :favorites, :customer, index: true
    add_foreign_key :favorites, :customers
  end

  def down
    remove_reference :favorites, :customer
    remove_foreign_key :favorites, :customers
  end

end
