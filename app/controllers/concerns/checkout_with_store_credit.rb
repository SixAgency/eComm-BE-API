module CheckoutWithStoreCredit
  extend ActiveSupport::Concern

  included do
    before_action :add_store_credit_payments, only: [:update]
  end

  def add_store_credit_payments
    authorize! :update, @order, order_token

    if params.has_key? :apply_store_credit
      apply_store_credit = params.delete :apply_store_credit

      if apply_store_credit
        @order.add_store_credit_payments
      else
        @order.payments.store_credits.where(state: 'checkout').map(&:invalidate!)
      end

      respond_with(@order, default_template: 'spree/api/v1/orders/show') and return
    end
  end
end