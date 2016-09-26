class AddContextToContactForms < ActiveRecord::Migration
  def change

    add_column :contact_forms, :sub_type, :string

  end
end
