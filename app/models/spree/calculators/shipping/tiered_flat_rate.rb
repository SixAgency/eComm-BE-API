module Spree
  module Calculators::Shipping
    class TieredFlatRate < ShippingCalculator
      preference :currency,        :string,  default: ->{ Spree::Config[:currency] }
      preference :first_item,      :decimal, default: 0.0
      preference :prices_by_quantity, :hash,    default: {}

      validate :preferred_prices_by_quantity_content

      def self.description
        Spree.t(:tiered_flat_rate)
      end

      def compute_package(package)
        compute_from_quantity(package.contents.sum(&:quantity))
      end

      def compute_from_quantity(quantity)
        prices = preferred_prices_by_quantity.select{ |key, _| key.to_i <= quantity }
        return prices.max_by{|k, v| k.to_i}.last.to_f if prices.count > 0
        return preferred_first_item
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
