# This migration comes from spree_store_credits (originally 20140702153907)
class AddGiftCardFlagToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :gift_card, :boolean, default: false
  end
end
