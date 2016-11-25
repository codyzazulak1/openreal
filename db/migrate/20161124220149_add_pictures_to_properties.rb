class AddPicturesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :pictures, :json
  end
end
