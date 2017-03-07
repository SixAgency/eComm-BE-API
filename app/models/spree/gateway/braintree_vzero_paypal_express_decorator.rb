module Spree
  Gateway::BraintreeVzeroPaypalExpress.class_eval do

    # This method will implement refund feature on cancel order action.
    def cancel(response_code)
      transaction = ::Braintree::Transaction.find(response_code)

      ## From: https://www.braintreepayments.com/docs/ruby/transactions/refund
      ## "A transaction can be refunded if its status is settled or settling.
      ## If the transaction has not yet begun settlement, it should be voided instead of refunded.

      if transaction.status == Braintree::Transaction::Status::SubmittedForSettlement
        void(response_code)
      else
        credit(sprintf('%02.f', transaction.amount*100), response_code, {})
      end
    end
  end
end