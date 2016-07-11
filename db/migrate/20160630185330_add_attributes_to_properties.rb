class AddAttributesToProperties < ActiveRecord::Migration
  def change
    change_table :properties do |t|
      t.text :seller_info
      t.string :pid
      t.text :address
      t.string :dwelling_class
      t.string :property_type
      t.string :building_type
      t.string :title_to_land
      t.string :sellers_interest
      t.string :architecture_style
      t.integer :number_of_floors
      t.integer :floor_area
      t.integer :year_built
      t.integer :list_price
      t.integer :stories
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :fireplaces
    end

    add_column :properties, :lot_length, :decimal, precision: 8, scale: 2
    add_column :properties, :lot_width, :decimal, precision: 8, scale: 2

  end
end
