module Documentation
  module Orders
    module CalculateShippingDoc
      extend ActiveSupport::Concern

      included do
        swagger_api :calculate_shipping do
          summary "Calculates and updates shipping based on zipcode, country_id and state_id."
          param :shipments_attributes, :zipcode, :integer, :required, 12121
          param :shipments_attributes, :country_id, :integer, :required, 1212121
          param :shipments_attributes, :state_id, :integer, :required, 121212
          response 200, "Shipp Address and Order updated", "Spree::Order"
          response 422
        end
      end
    end
  end
end

