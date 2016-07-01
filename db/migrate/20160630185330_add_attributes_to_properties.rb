class AddAttributesToProperties < ActiveRecord::Migration
  def change
    change_table :properties do |t|
      t.text :seller_info
      t.string :pid
      t.text :address
      t.integer :bedrooms
      t.integer :full_baths
      t.integer :half_baths
      t.integer :area
      t.integer :age
      t.string :zoning
      t.string :ownership
    end
  end
end
