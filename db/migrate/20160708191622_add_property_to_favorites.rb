class AddPropertyToFavorites < ActiveRecord::Migration
  def up
    add_reference :favorites, :property, index: true
    add_foreign_key :favorites, :properties
  end

  def down
    remove_reference :favorites, :property
    remove_foreign_key :favorites, :properties
  end
end
