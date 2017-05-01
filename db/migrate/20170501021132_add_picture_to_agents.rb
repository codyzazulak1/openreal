class AddPictureToAgents < ActiveRecord::Migration
  def change
  	add_column :agents, :profile_picture, :string
  end
end
