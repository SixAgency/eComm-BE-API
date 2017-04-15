module CheckoutWithStoreCredit
  extend ActiveSupport::Concern

  included do
    before_action :add_store_credit_payments, only: [:update]
  end

  def add_store_credit_payments
    authorize! :update, @order, order_token

    if params.delete(:apply_store_credit)
      @order.add_store_credit_payments

      # Remove other payment method parameters.
      if params[:order]
        params[:order].delete(:payments_attributes)
        params[:order].delete(:existing_card)
      end

      params.delete(:payment_source)

      # Return to the Payments page if additional payment is needed.
      if @order.payments.valid.sum(:amount) < @order.total
        respond_with(@order, default_template: 'spree/api/v1/orders/show') and return
      end
    end
  end
end