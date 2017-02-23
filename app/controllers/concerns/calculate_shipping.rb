module CalculateShipping
  def self.included(base)
    base.class_eval do
      swagger_controller :orders, "Shipping Calculation"

      include Documentation::Orders::CalculateShippingDoc
      def calculate_shipping
        find_order(true)
        authorize! :update, @order, order_token

        add_missing_shipping_params

        if @order.ship_address.update_attributes(order_shipp_address_params)

          @order.create_proposed_shipments
          @order.set_shipments_cost
          @order.apply_free_shipping_promotions

          @order.update_totals
          @order.persist_totals

          @order.reload

          respond_with(@order, default_template: :show)
        else
          invalid_resource!(@order.ship_address)
        end

      end

      private

      def order_shipp_address_params
        params.require(:shipments_attributes).permit(:zipcode, :country_id, :state_id, :firstname,
                                                     :lastname, :address1, :city, :phone)
      end

      def add_missing_shipping_params
        fake = {firstname: 'Add first name', lastname: 'Add last name',
                address1: 'Add address', city: 'Add city', phone: 12221244}

        params[:shipments_attributes].merge!(fake) { |key, v1, v2| v1 }
      end
    end
  end
end