module Spree
  class Gateway::SquareUpGateway < Gateway

    preference :access_token,   :string
    preference :application_id, :string

    def provider_class
      ActiveMerchant::Billing::SquareUp
    end

    def method_type
      'square_up'
    end

    def payment_profiles_supported?
      true
    end

    #
    # Cancel the payment
    #
    # If the payment was not captured, void it.
    # If it was captured refunds all the money.
    #
    def cancel(transaction_id)
      response = provider.void(transaction_id, nil)
      provider.refund(nil, nil, transaction_id, {refund_all: true}) unless response.success?
    end

    def create_customer(payment)
      provider.customer(payment.source, order: payment.order)
    end

    def create_profile(payment)
      #
      # We don't have a token, but we have a nonce
      #
      if payment.source.gateway_payment_profile_id.nil? && payment.source.encrypted_data.present?
        response = provider.store(payment.source, order: payment.order)

        if response.success?
          payment.source.update_attributes!(gateway_payment_profile_id: response.object.card.id)
        else
          payment.send(:gateway_error, response.message)
        end
      end
    end
  end
end
