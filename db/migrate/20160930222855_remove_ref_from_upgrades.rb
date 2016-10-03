class RemoveRefFromUpgrades < ActiveRecord::Migration
  def change
  	remove_foreign_key :upgrades, column: :property_id
  end
end
