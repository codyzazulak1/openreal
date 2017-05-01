class AddAgentsToProperties < ActiveRecord::Migration
  def change
    add_reference :properties, :agent, index: true
    add_foreign_key :properties, :agents
  end
end
