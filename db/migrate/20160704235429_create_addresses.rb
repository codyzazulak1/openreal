class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_first
      t.string :address_second
      t.string :street
      t.string :city

      t.timestamps null: false
    end
  end
end
