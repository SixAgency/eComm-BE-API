module LimitLineItemQuantity

    def merge!(other_order, user = nil)
      product_count = {}

      order.line_items.each do |order_line_item|
        product_count[order_line_item.product.id] ||= 0
        product_count[order_line_item.product.id] += order_line_item.quantity
      end

      other_order.line_items.each do |other_order_line_item|
        next unless other_order_line_item.currency == order.currency

        product_count[other_order_line_item.product.id] ||= 0
        product_count[other_order_line_item.product.id] += other_order_line_item.quantity
      end

      other_order.line_items.each do |other_order_line_item|
        next unless other_order_line_item.currency == order.currency

        product_id = other_order_line_item.product.id
        if other_order_line_item.product.max_quantity_allowed_in_cart < product_count[product_id]
          to_remove_count = product_count[product_id] - other_order_line_item.product.max_quantity_allowed_in_cart

          if other_order_line_item.quantity <= to_remove_count
            product_count[product_id] -= other_order_line_item.quantity
            other_order_line_item.quantity = 0
          else
            product_count[product_id] -= to_remove_count
            other_order_line_item.quantity -= to_remove_count
          end
        end
      end

      super

      order.line_items.reload
      order.line_items.select{ |item| item.quantity <= 0 }.each { |item| item.destroy }
    end
end