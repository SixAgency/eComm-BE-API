module Spree
  module Calculators
    class QuantityRate < Calculator
      preference :prices_by_quantity, :hash,    default: {}
      preference :currency,           :string,  default: ->{ Spree::Config[:currency] }

      validate :preferred_prices_by_quantity_content

      def self.description
        Spree.t(:quantity_rate)
      end

      def compute(item)
        prices = preferred_prices_by_quantity.select{ |key, _| key.to_i <= item.quantity }
        return prices.max_by{|k, v| k.to_i}.last.to_f if prices.count > 0
        return 0.0
      end

      private
      def preferred_prices_by_quantity_content
        if preferred_prices_by_quantity.is_a? Hash
          unless preferred_prices_by_quantity.all?{ |k, v| k.to_i >= 0 && v.to_i >= 0 }
            errors.add(:preferred_prices_by_quantity, :should_contain_positive_numbers)
          end
        else
          errors.add(:preferred_prices_by_quantity, :should_be_hash)
        end
      end
    end
  end
end
