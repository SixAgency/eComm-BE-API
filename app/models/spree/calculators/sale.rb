module Spree
  module Calculators
    class Sale < Calculator
      def self.description
        Spree.t(:sale)
      end

      def compute(object)
        (object.amount * object.sale / 100)
      end
    end
  end
end