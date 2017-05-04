class ChangeSaleTypeInSpreeProducts < ActiveRecord::Migration[5.0]
  def change
    change_column :spree_products, :sale, :decimal, precision: 10, scale: 2
  end
end
