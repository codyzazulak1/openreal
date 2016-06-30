class AddAttributesToProperties < ActiveRecord::Migration
  def change
    change_table :properties do |t|
      t.decimal :estimate, :precision => 12, :scale => 2
      t.text :seller_info
      t.string :pid
      t.text :address
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :square_feet
    end
  end
end
