class AddKeysToPropertyUpgrades < ActiveRecord::Migration
  def change

    add_reference :property_upgrades, :property, index: true, foreign_key: true
    add_reference :property_upgrades, :upgrade, index: true, foreign_key: true

  end
end
