class ChangeListPriceToListPriceCents < ActiveRecord::Migration
  def change
    rename_column :properties, :list_price, :list_price_cents
  end
end
