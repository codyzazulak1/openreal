class RemovePropertyRefFromUpgrades < ActiveRecord::Migration
  def change
  	remove_foreign_key :upgrades, :property_id
  end
end
