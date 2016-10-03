class AddTimeframeToContactForms < ActiveRecord::Migration
  def change
  	add_column :contact_forms, :timeframe, :integer
  end
end
