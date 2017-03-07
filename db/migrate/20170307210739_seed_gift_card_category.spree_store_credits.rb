# This migration comes from spree_store_credits (originally 20140624175113)
class SeedGiftCardCategory < ActiveRecord::Migration
  def change
    add_column :spree_store_credit_categories, :position, :integer

    Spree::StoreCreditCategory.find_or_create_by(name: 'Gift Card')
  end
end
