module Spree
  class Promotion
    module Rules
      class PromotableOnly < Spree::PromotionRule

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, _options = {})
          order.line_items.all?{ |item| actionable?(item) }
        end

        def actionable?(line_item)
          line_item.product.promotionable?
        end
      end
    end
  end
end
