class AddDefaultStatusToProperties < ActiveRecord::Migration

  def up
    change_column_default :properties, :status, 'Listed'
  end

  def down

  end

end
