class RemovePhotoFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :photo, :string
  end
end
