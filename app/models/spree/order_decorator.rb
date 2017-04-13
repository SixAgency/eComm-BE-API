Spree::Order.send :include, OrderEmailDelivery, Spree::GiftCard::OrderConcern

Spree::Order.class_eval do
  # guest orders are one time customers from Square's point of view.
  has_one :square_customer, as: :owner

  def persist_user_address!; end

  def reset!
    if completed?
      raise Spree.t(:cannot_empty_completed_order)
    else
      shipments.destroy_all
      state_changes.destroy_all
      payments.with_state('checkout').each do |payment|
        payment.invalidate!
      end

      update_totals
      persist_totals
      restart_checkout_flow
      self
    end
  end

end
