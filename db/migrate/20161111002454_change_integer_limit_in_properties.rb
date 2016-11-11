class ChangeIntegerLimitInProperties < ActiveRecord::Migration
  def change
  	change_column :properties, :list_price_cents, :integer, limit: 8
  end
end
