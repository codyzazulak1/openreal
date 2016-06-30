class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :properties, :agents
    add_foreign_key :properties, :customers
    add_foreign_key :wishlists, :customers
    add_foreign_key :favorites, :customers
    add_foreign_key :favorites, :wishlists
    add_foreign_key :appointments, :customers
    add_foreign_key :appointments, :properties
    add_foreign_key :appointments, :admins
  end
end
