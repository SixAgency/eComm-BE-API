module CheckoutReset

  def reset
    authorize! :update, @order, order_token
    @order.reset!
    respond_with(@order, default_template: 'spree/api/v1/orders/show', status: 200)
  end
end