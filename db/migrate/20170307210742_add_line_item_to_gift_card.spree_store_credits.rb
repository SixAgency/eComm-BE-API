# This migration comes from spree_store_credits (originally 20140707200431)
class AddLineItemToGiftCard < ActiveRecord::Migration
  def change
    add_column :spree_virtual_gift_cards, :line_item_id, :integer

    add_index :spree_virtual_gift_cards, :line_item_id
  end
end
