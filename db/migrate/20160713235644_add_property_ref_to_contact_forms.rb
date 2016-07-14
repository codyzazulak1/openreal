class AddPropertyRefToContactForms < ActiveRecord::Migration
  def change
    add_reference :contact_forms, :property, index: true, foreign_key: true
  end
end
