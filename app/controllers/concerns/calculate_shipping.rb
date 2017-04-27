module CalculateShipping

  def calculate_shipping
    authorize! :show, @order, order_token
    @order.build_ship_address(order_ship_address_params)

    adjust_tax
    calculate_shipping_rates
    respond_with(@order, default_template: :show)
  end

  private
  def order_ship_address_params
     params.require(:shipments_attributes).permit(:zipcode, :country_id, :state_id)
  end

  def calculate_shipping_rates
    shipment = @order.shipments.new(stock_location: default_stock_location)
    shipment.shipping_rates = Spree::Stock::Estimator.new(@order).shipping_rates(package).map do | shipping_rate |
      shipping_rate.shipment = shipment
      shipment.cost = shipping_rate.cost if shipping_rate.selected
      shipping_rate
    end
    @order.shipment_total = shipment.cost
    @order.updater.update_order_total
  end

  def adjust_tax
    Spree::TaxRate.adjust(@order, @order.line_items)
    @order.update_totals
  end

  def package
    package = Spree::Stock::Package.new(default_stock_location)
    package.add_multiple(@order.line_items)
    package
  end

  def default_stock_location
    Spree::StockLocation.active.first
  end
end