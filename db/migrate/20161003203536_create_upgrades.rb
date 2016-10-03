class CreateUpgrades < ActiveRecord::Migration
  def change
    create_table :upgrades do |t|

      t.string :name

    end
  end
end
