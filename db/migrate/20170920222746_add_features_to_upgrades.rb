class AddFeaturesToUpgrades < ActiveRecord::Migration
  def change
		add_column :upgrades, :feature, :string
  end
end
