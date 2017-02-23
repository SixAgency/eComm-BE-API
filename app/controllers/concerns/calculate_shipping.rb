module CalculateShipping
  def self.included(base)
    base.class_eval do
      swagger_controller :orders, "Shipping Calculation"

      include Documentation::Orders::CalculateShippingDoc
      def calculate_shipping
        find_order(true)
        authorize! :update, @order, order_token
        add_missing_shipping_params

        exists_ship_address? ? update_ship_address : create_ship_address
      end

      private

      def order_shipp_address_params
        params.require(:shipments_attributes).permit(:zipcode, :country_id, :state_id, :firstname,
                                                     :lastname, :address1, :city, :phone)
      end

      def add_missing_shipping_params
        fake = {firstname: 'Add first name', lastname: 'Add last name',
                address1: 'Add address', city: 'Add city', phone: 12221244}

        params[:shipments_attributes].merge(fake) { |key, v1, v2| v1 }
      end

      def exists_ship_address?
        !@order.ship_address.nil?
      end

      def create_ship_address
        @new_ship_address = @order.build_ship_address(order_shipp_address_params)

        success_ship_create
        unsuccess_ship_create
      end

      def success_ship_create
        resolve_calc if ship_address_exists?
      end

      def unsuccess_ship_create
        invalid_resource!(@new_ship_address) unless ship_address_exists?
      end

      def ship_address_exists?
        @ship_address_exists ||= @new_ship_address.save
      end

      def update_ship_address
        success_ship_update
        unsuccess_ship_update
      end

      def success_ship_update
        resolve_calc if success_updated?
      end

      def unsuccess_ship_update
        invalid_resource!(@order.ship_address) unless success_updated?
      end

      def success_updated?
        @old_ship_address ||= @order.ship_address.update_attributes(order_shipp_address_params)
      end

      def resolve_calc
        @order.save
        @order.create_proposed_shipments
        @order.set_shipments_cost
        @order.apply_free_shipping_promotions

        @order.update_totals
        @order.persist_totals

        @order.reload

        respond_with(@order, default_template: :show)
      end
    end
  end
end