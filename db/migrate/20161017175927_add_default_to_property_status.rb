class AddDefaultToPropertyStatus < ActiveRecord::Migration
  def change

    change_column_default :properties, :status_id, 1
    
  end
end
