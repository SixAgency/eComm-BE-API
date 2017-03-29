class AddSaleToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_products, :sale, :integer, default: 0, null: false
  end
end

Spree::PromotionHandler