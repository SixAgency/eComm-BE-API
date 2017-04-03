module VariantDelegates

  delegate :sale, to: :product
  delegate :is_sale, to: :product
  delegate :max_quantity_allowed_in_cart, to: :product

  def images
    images = super
    images.present? ? images : product.images
  end
end