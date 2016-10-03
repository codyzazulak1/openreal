class CreateJoinTablePropertyUpgrade < ActiveRecord::Migration
  def change
    create_join_table :properties, :upgrades do |t|
      # t.index [:property_id, :upgrade_id]
      # t.index [:upgrade_id, :property_id]
    end
  end
end
