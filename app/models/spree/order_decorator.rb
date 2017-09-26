Spree::Order.send :include, OrderEmailDelivery, Spree::GiftCard::OrderConcern,
                            ResetPartialAddresses

Spree::Order.class_eval do
  # guest orders are one time customers from Square's point of view.
  has_one :square_customer, as: :owner

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

  def subtotal
    ad_total = adjustments.map { |adj| adj.label.include?('Promotion') ? 0 : adj.amount }.sum
    return item_total + adjustment_total - additional_tax_total - ad_total
  end

  def sale_amount
    line_items.inject(0.0) { |sum, li| sum + li.sale_amount }
  end

  def self.to_csv(orders)
    headers = ["Order Date", "Order #", "Shipping Method", "Email", "Name",
               "Address 1", "Address 2", "City", "State", "Zip", "Item Count",
               "Order Total", "Subtotal", "Tax Total", "Shipping"]

    max_order_items = orders.map{ |o| o.line_items.count }.max
    max_order_items.times do |i|
      headers << "Item #{i+1} SKU"
      headers << "Item #{i+1} Qty"
      headers << "Item #{i+1} Total"
    end

    CSV.generate do |csv|
      csv << headers

      orders.each do |order|
        row = [order.completed_at.try(:strftime, "%m/%d/%Y"),
               order.number,
               order.shipments.map(&:shipping_method).compact.map(&:name).uniq.join(", "),
               order.email,
               order.name,
               order.shipping_address.try(:address1),
               order.shipping_address.try(:address2),
               order.shipping_address.try(:city),
               order.shipping_address.try(:state).try(:name),
               order.shipping_address.try(:zipcode),
               order.line_items.count,
               order.total,
               order.item_total,
               order.tax_total,
               order.shipments.map(&:cost).sum]

        order.line_items.each do |li|
          row << li.sku
          row << li.quantity
          row << li.total.to_s
        end
        remaining_items = max_order_items - order.line_items.count
        row << [""] * remaining_items * 4

        csv << row.flatten
      end
    end
  end
end
