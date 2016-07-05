class RemovePostalCodeFromProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :postal_code, :string
  end
end
