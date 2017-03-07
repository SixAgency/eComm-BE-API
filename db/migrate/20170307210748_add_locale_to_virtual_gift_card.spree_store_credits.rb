# This migration comes from spree_store_credits (originally 20160111221406)
class AddLocaleToVirtualGiftCard < ActiveRecord::Migration
  def up
    add_column :spree_virtual_gift_cards, :locale, :string
  end

  def down
    remove_column :spree_virtual_gift_cards, :locale, :string
  end
end