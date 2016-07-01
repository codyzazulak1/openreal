class AddStatusesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :status, :string
  end
end
