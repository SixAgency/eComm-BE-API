Spree::LineItem.include(Spree::LineItemDecorator)

module Spree::LineItemDecorator
  def self.included(base)
    base.has_many :gift_cards, class_name: Spree::VirtualGiftCard, dependent: :destroy
    base.delegate :gift_card?, :gift_card, to: :product
    base.prepend(InstanceMethods)
    base.whitelisted_ransackable_associations += %w[order]
  end

  module InstanceMethods
    def redemption_codes
      gift_cards.map {|gc| {amount: gc.formatted_amount, redemption_code: gc.formatted_redemption_code}}
    end

    def gift_card_details
      gift_cards.map(&:details)
    end
  end
end