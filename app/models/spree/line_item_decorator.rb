Spree::LineItem.include Spree::GiftCard::LineItemHasGiftCard

Spree::LineItem.class_eval do
  delegate :sale, to: :product
end
