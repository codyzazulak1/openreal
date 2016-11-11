class AddMatterUrlToProperties < ActiveRecord::Migration

  def up

    add_column :properties, :matterurl, :string

  end

  def down

    remove_column :properties, :matterurl

  end


end
