class AddCompanyNameToAgents < ActiveRecord::Migration
  def change
  	add_column :agents, :company_name, :string
  end
end
