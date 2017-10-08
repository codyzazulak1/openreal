class AddSectionToUpgrades < ActiveRecord::Migration
  def change
			add_column :upgrades, :section, :string
  end
end
