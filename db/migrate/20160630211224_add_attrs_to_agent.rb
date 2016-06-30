class AddAttrsToAgent < ActiveRecord::Migration
  def change
    change_table :agents do |t|
      t.string :phone
      t.string :agent_number
    end
  end
end
