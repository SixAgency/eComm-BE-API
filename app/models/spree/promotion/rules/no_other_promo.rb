module Spree
  class Promotion
    module Rules
      class NoOtherPromo < Spree::PromotionRule

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, _options = {})
          order.line_items.any?{ |item| actionable?(item) }
        end

        def actionable?(line_item)
          !line_item.adjustments.any? do |adjustment|
            adjustment.source_type == 'Spree::PromotionAction' &&
            adjustment.source.promotion_id != promotion.id
          end
        end
      end
    end
  end
end
