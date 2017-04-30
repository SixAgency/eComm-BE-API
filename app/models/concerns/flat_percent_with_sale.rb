module FlatPercentWithSale
  def compute(object)
    if object.respond_to? :sale_amount
      [(object.sale_amount * preferred_flat_percent / 100).round(2), object.sale_amount].min
    else
      super
    end
  end
end