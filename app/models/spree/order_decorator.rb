Spree::Order.send :include, OrderEmailDelivery

Spree::Order.class_eval do
  # guest orders are one time customers from Square's point of view.
  has_one :square_customer, as: :owner

  def persist_user_address!; end
end

