class AddPropertyRefToAddresses < ActiveRecord::Migration
  def change
    add_reference :addresses, :property, index: true, foreign_key: true
  end
end
