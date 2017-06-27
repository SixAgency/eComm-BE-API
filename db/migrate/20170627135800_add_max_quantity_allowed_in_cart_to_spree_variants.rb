class AddMaxQuantityAllowedInCartToSpreeVariants < ActiveRecord::Migration[5.0]
  def up
    add_column :spree_variants, :max_quantity_allowed_in_cart, :integer, default: 0, null: false
    remove_column :spree_products, :max_quantity_allowed_in_cart
  end

  def down
    add_column :spree_products, :max_quantity_allowed_in_cart, :integer, default: 0, null: false
    add_column :spree_variants, :max_quantity_allowed_in_cart
  end
end
