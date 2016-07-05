class AddPostalCodeToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :postal_code, :string
  end
end
