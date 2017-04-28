class AddAgentsToProperties < ActiveRecord::Migration
  def change
  	add_reference :properties, :agent, index: true, foreign_key: true
  end
end
