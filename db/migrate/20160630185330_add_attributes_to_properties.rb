class AddAttributesToProperties < ActiveRecord::Migration
  def change
    change_table :properties do |t|
      t.decimal :price, :precision => 12, :scale => 2
      t.decimal :estimate, :precision => 12, :scale => 2
      t.text :seller_info
      t.string :pid
    end
  end
end
