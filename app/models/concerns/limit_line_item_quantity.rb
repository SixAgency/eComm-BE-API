module LimitLineItemQuantity

    def handle_merge(current_line_item, other_order_line_item)
        super
        if current_line_item
            current_line_item.quantity = [current_line_item.quantity,
                                          current_line_item.variant.max_quantity_allowed_in_cart].min
            handle_error(current_line_item) unless current_line_item.save
        end
    end
end