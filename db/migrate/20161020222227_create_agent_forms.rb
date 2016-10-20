class CreateAgentForms < ActiveRecord::Migration
  def change
    create_table :agent_forms do |t|

      t.string :full_name
      t.string :email
      t.string :company_name

      t.timestamps null: false
    end
  end
end
