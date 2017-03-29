Spree::Promotion.singleton_class.class_eval do
  def sale
    where(name: 'Sale').first_or_create
  end
end