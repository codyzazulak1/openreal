class ChangeNameInAdmins < ActiveRecord::Migration
  def self.up
    rename_column :admins, :name, :first_name
    add_column :admins, :last_name, :string
  end

  def self.down
    rename_column :admins, :first_name, :name
    remove_column :admins, :last_name, :string
  end
end
