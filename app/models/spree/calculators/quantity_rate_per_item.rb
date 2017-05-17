module Spree
  module Calculators
    class QuantityRatePerItem < QuantityRate

      def self.description
        Spree.t(:quantity_rate_per_item)
      end

      def compute(item)
        adjusmet_amount = super
        return adjusmet_amount * item.quantity
      end
    end
  end
end
