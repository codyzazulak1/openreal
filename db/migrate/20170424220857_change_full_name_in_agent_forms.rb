class ChangeFullNameInAgentForms < ActiveRecord::Migration
  def change
  	add_column :agent_forms, :last_name, :string
  	rename_column :agent_forms, :full_name, :first_name
  end
end
