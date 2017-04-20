module CalculateShipping
  def calculate_shipping
    authorize! :show, @order, order_token
    @order.build_ship_address(order_ship_address_params)
    @shipping_rates = shipping_rates
    respond_with(@shipping_rates, default_template: :shipping_rates)
  end

  private
  def order_ship_address_params
     params.require(:shipments_attributes).permit(:zipcode, :country_id, :state_id)
  end

  def shipping_rates
    shipment = @order.shipments.new
    Spree::Stock::Estimator.new(@order).shipping_rates(package).map do | shipping_rate |
      shipping_rate.shipment = shipment
      shipping_rate
    end
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