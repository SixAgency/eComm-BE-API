Spree::Product.class_eval do
  validates :sale, inclusion: 0..99

  def sale?
    sale > 0
  end
  alias_method :is_sale, :sale?

end
