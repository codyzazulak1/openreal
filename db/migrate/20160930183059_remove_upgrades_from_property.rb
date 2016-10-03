class RemoveUpgradesFromProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :kitchen_upgrades, :boolean
    remove_column :properties, :bathroom_upgrades, :boolean
    remove_column :properties, :basement_upgrades, :boolean
    remove_column :properties, :pool_upgrades, :boolean
  end
end
