# This migration comes from spree_store_credits (originally 20151013172931)
class AddRecipientFieldsToVirtualGiftCard < ActiveRecord::Migration
  def change
    add_column :spree_virtual_gift_cards, :recipient_name, :string
    add_column :spree_virtual_gift_cards, :recipient_email, :string
    add_column :spree_virtual_gift_cards, :gift_message, :text
    add_column :spree_virtual_gift_cards, :purchaser_name, :string
  end
end
