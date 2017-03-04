class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :full_name
      t.string :email

      t.timestamps null: false
    end
  end
end
