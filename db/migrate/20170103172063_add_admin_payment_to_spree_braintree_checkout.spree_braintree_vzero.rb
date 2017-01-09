# This migration comes from spree_braintree_vzero (originally 20160112153422)
class AddAdminPaymentToSpreeBraintreeCheckout < ActiveRecord::Migration
  def change
    add_column :spree_braintree_checkouts, :admin_payment, :bool
  end
end
