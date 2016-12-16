module Spree
  module Api
    module V1
      class UserAddressesController < Spree::Api::BaseController
        before_action :respond_not_found, only: [:show, :update, :destroy]

        def index
          authorize! :read, Spree::Address

          respond_with_resource 200
        end

        def create
          @address = current_api_user.spree_addresses.new(address_params)

          if @address.save
            render status: 201, json: { address: @address }
          else
            render status: 422, json: { errors: @address.errors }
          end
        end

        def show
          authorize! :read, Spree::Address

          render status: 200, json: { address: resource }
        end

        def update
          authorize! :update, Spree::Address

          if resource.update_attributes(address_params)
            render status: 200, json: { address: resource }
          else
            render status: 422, json: {}
          end
        end

        def destroy
          authorize! :destroy, Spree::Address
          resource.destroy
          render status: 204, json: {}
        end

        private

        def resource
          @address ||= current_api_user.spree_addresses.find_by_id(params[:id])
        end

        def address_params
          params.require(:address).permit(:firstname, :lastname, :address1, :address2, :city, :zipcode, :phone,
                                          :state_name, :alternative_phone, :company, :state_id, :country_id)
        end

        def respond_with_resource(status)
          render status: status, json: { owner_address: current_api_user.spree_addresses,
                                         ship_address: current_api_user.ship_address,
                                         bill_address: current_api_user.bill_address }
        end

        def respond_not_found
          render status: 404, json: { error: 'Address not found'} unless resource
        end

      end
    end
  end
end