class CreateUpgrades < ActiveRecord::Migration
  def change
    create_table :upgrades do |t|
      t.boolean :kitchen
      t.boolean :bathroom
      t.boolean :pool
      t.boolean :basement

      t.references :property, index:true

      t.timestamps null:false
    end
  end
end
