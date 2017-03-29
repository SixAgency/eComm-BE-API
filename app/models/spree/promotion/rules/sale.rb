module Spree
  class Promotion
    module Rules
      class Sale < Spree::PromotionRule

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          order.line_items.map(&:sale).sum
        end

        def actionable?(line_item)
          line_item.sale > 0
        end
      end
    end
  end
end
