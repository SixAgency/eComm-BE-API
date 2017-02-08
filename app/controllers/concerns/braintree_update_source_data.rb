module BraintreeUpdateSourceData
  extend ActiveSupport::Concern

  included do
    after_action :update_source_data, only: :update, if: proc { params[:state].eql?('payment') }
  end

  private

  def update_source_data
    return true unless current_order
    payment = current_order.payments.last
    return true unless payment
    source = payment.source
    return true unless source.is_a?(Spree::BraintreeCheckout)
    update_advanced_fraud_data(source)
  end

  def update_advanced_fraud_data(source)
    source.update(advanced_fraud_data: params[:device_data])
  end
end
