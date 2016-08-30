class AddStatusToContactForms < ActiveRecord::Migration
  def change
    add_column :contact_forms, :status, :string
  end
end
