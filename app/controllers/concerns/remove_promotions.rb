module RemovePromotions

  def remove_promotions
    authorize! :update, @order, order_token
    @order.adjustments.destroy_all
    @order.promotions.clear
    @order.update_totals
    @order.persist_totals
    respond_with(@order, default_template: :show)
  end
end
