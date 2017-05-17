class AddNotesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :note, :text
  end
end
