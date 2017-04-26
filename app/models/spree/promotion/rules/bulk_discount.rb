module Spree
  class Promotion
    module Rules
      class BulkDiscount < Spree::PromotionRule
        preference :min_quantites, :hash

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, _options = {})
          order.line_items.any? { |item| actionable?(item) }
        end

        def actionable?(line_item)
          pid = line_item.product.id.to_s
          product_ids.include?(pid) && (line_item.quantity >= min_quantity(pid))
        end

        private
        def product_ids
          preferred_min_quantites.keys
        end

        def min_quantity(product_id)
          preferred_min_quantites[product_id].to_i
        end
      end
    end
  end
end
