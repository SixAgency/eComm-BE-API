# This migration comes from spree_store_credits (originally 20151013210615)
class AddActiveFlagToVirtualGiftCard < ActiveRecord::Migration
  def change
    add_column :spree_virtual_gift_cards, :redeemable, :boolean, default: false
  end
end
