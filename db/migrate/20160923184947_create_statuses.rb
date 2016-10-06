class CreateStatuses < ActiveRecord::Migration
  def change

    create_table :statuses do |t|

      t.timestamps
      t.string :type
      t.string :name

    end

    add_reference :properties, :status, index: true, foreign_key: true

  end
end
