class AddPostalCodeToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :postal_code, :string
  end
end
