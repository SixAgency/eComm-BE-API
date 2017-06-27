Spree::Product.class_eval do
  validates :sale, inclusion: 0..99
  delegate_belongs_to :master, :max_quantity_allowed_in_cart

  def sale?
    sale > 0
  end
  alias_method :is_sale, :sale?

end
