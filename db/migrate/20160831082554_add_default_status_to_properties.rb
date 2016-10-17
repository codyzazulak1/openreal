class AddDefaultStatusToProperties < ActiveRecord::Migration

  def up
    change_column_default :properties, :status_id, 1
  end

  def down

  end

end
