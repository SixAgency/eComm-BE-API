module BraintreeApiIntegration
  extend ActiveSupport::Concern

  included do
    before_action :process_paypal_express, only: :update
  end

  def process_paypal_express
    if params[:paypal].blank? || params[:paypal][:payment_method_nonce].blank?
      # when user goes back from checkout, paypal express payments should be invalidated  to ensure standard checkout flow
      @order.invalidate_paypal_express_payments
      return true
    end

    payment_method = Spree::PaymentMethod.find_by_id(params[:paypal][:payment_method_id])
    return true unless payment_method

    email = params[:order][:email]
    # when user goes back from checkout, order's state should be resetted to ensure paypal checkout flow
    @order.state = 'cart'
    @order.save_paypal_payment(payment_params)

    manage_paypal_addresses
    payment_method.push_order_to_state(@order, 'address', email)
    @order.remove_phone_number_placeholder
  end

  private

  def payment_params
    {
        braintree_nonce: params[:paypal][:payment_method_nonce],
        payment_method_id: params[:paypal][:payment_method_id],
        paypal_email: params[:order][:email],
        advanced_fraud_data: params[:device_data]
    }
  end

  def manage_paypal_addresses
    # addresses need to be cleared for restarted checkout orders
    @order.ship_address_id = nil
    @order.bill_address_id = nil

    %w(ship_address bill_address).each do |address_type|
      next if params[:order][address_type].blank?
      @order.save_paypal_address(address_type, braintree_address_params(address_type))
    end
    @order.set_billing_address
    return false if @order.no_phone_number?

    @order.ship_address && @order.bill_address
  end

  def braintree_address_params(key)
    params[:order].require(key).permit(:firstname, :lastname, :zipcode, :city, :address1, :address2,
                                       :phone, :full_name, :country, :state, :user_address_id)
  end
end
