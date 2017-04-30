Spree::LineItem.include Spree::GiftCard::LineItemHasGiftCard

Spree::LineItem.class_eval do
  delegate :sale, to: :product

  def sale_amount
    amount + adjustments.select do |a|
      (a.source.promotion.id == Spree::Promotion.sale.id) rescue nil
    end.map(&:amount).sum
  end
end
