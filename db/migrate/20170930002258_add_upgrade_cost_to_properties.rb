class AddUpgradeCostToProperties < ActiveRecord::Migration
  def change
		add_column :properties, :upgrade_cost, :integer, default: 0
  end
end
