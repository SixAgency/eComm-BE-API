Spree::LineItem.include Spree::GiftCards::LineItemConcerns

Spree::LineItem.class_eval do
  delegate :sale, to: :product
end
