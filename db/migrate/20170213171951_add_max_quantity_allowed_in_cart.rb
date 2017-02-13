class AddMaxQuantityAllowedInCart < ActiveRecord::Migration[5.0]
  def up
    add_column :spree_products, :max_quantity_allowed_in_cart, :integer, default: 0, null: false
  end

  def down
    remove_column :spree_products, :max_quantity_allowed_in_cart
  end
end
