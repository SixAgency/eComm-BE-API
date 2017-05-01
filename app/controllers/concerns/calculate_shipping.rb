module CalculateShipping

  def calculate_shipping
    authorize! :show, @order, order_token
    @order.build_ship_address(order_ship_address_params.merge({partial: true}))

    @order.create_proposed_shipments
    @order.set_shipments_cost
    @order.apply_free_shipping_promotions
    
    @order.update_columns(state: 'cart')
    @order.update_line_item_prices!
    @order.create_tax_charge!
    @order.update_totals
    @order.persist_totals
    respond_with(@order, default_template: :show)
  end

  private
  def order_ship_address_params
     params.require(:shipments_attributes).permit(:zipcode, :country_id, :state_id)
  end
end
