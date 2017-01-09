# This migration comes from spree_braintree_vzero (originally 20151211100203)
class AddBraintreeLastDigitsAndBraintreeCardTypeToSpreeBraintreeCheckouts < ActiveRecord::Migration
  def change
    add_column :spree_braintree_checkouts, :braintree_last_digits, :string, limit: 4
    add_column :spree_braintree_checkouts, :braintree_card_type, :string
  end
end
