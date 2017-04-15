Spree::Admin::OrdersController.class_eval do
  def cancel
    @order.cancel!  # this method must used for refund or void payment
    redirect_to :back
  end
end

# bellow states are informative.

# unpaid_not_shiped
#   {
#       order: {
#           state: 'complete',
#           payment_state: 'balance_due',
#           shipment_state: 'pending',
#       },
#       shipment_state: 'pending',
#       payment_state: 'pending'
#   }


# cancel_unpaid_not_shiped
#   {
#       order: {
#           state: 'canceled',
#           payment_state: 'balance_due',
#           shipment_state: 'canceled',
#       },
#       shipment_state: 'canceled',
#       payment_state: 'pending'
#   }


# paid_not_shiped
#   {
#       order: {
#           state: 'complete',
#           payment_state: 'paid',
#           shipment_state: 'ready',
#       },
#       shipment_state: 'ready',
#       payment_state: 'complete'
#   }


# cancel_paid_not_shiped
#   {
#       order: {
#           state: 'canceled',
#           payment_state: 'balance_due',
#           shipment_state: 'canceled',
#       },
#       shipment_state: 'canceled',
#       payment_state: 'complete'
#   }
#