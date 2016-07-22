class AddLatLongToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :latitude, :decimal, precision: 9, scale: 6
    add_column :addresses, :longitude, :decimal, precision: 9, scale: 6
  end
end
