# This migration comes from spree_store_credits (originally 20151019190731)
class AddEmailSendTimeToVirtualGiftCard < ActiveRecord::Migration
  def change
    add_column :spree_virtual_gift_cards, :send_email_at, :datetime
    add_column :spree_virtual_gift_cards, :sent_at, :datetime
    add_index :spree_virtual_gift_cards, :send_email_at
  end
end