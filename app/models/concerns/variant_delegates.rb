module VariantDelegates

  delegate :sale, to: :product
  delegate :is_sale, to: :product

  def images
    images = super
    return images if images.present? || is_master?
    return product.images
  end
end