class AddAttrsToCustomer < ActiveRecord::Migration
  def change
    change_table :customers do |t|
      t.text :address
      t.string :phone
      t.string :time_frame
      t.boolean :looking
    end
  end
end
