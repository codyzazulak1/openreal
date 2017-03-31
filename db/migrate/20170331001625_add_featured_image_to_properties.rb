class AddFeaturedImageToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :featured_photo, :string
  end
end
