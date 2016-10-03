class AddUpgradesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :kitchen_upgrades, :boolean
    add_column :properties, :bathroom_upgrades, :boolean
    add_column :properties, :basement_upgrades, :boolean
    add_column :properties, :pool_upgrades, :boolean
  end
end
