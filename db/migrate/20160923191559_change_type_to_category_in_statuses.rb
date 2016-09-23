class ChangeTypeToCategoryInStatuses < ActiveRecord::Migration
  def change

    rename_column :statuses, :type, :category

  end
end
