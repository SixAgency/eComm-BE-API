module Spree
  module Api
    module V1
      class UserAddressesController < Spree::Api::BaseController
        before_action :set_user
        before_action :set_address, only: [:show, :update, :destroy]

        def index
          authorize! :read, Spree::Address

          respond_with_user_and_addresses 200
        end

        def create
          @address = @user.spree_addresses.new(address_params)

          if @address.save
            respond_with_user_and_addresses 201
          else
            render status: 422, json: {}
          end

        end

        def show
          authorize! :read, Spree::Address

          render status: 200, json: { user: ecomm_user, address: @address }
        end

        def update
          authorize! :update, Spree::Address

          if @address.update_attributes(address_params)
            render status 200, json: { user: ecomm_user, address: @address }
          else
            render status: 422, json: {}
          end
        end

        def destroy
          authorize! :destroy, Spree::Address
          @address.destroy
          render status 204, json: {}
        end

        private

        def set_user
          @user = Spree::User.find_by_id(params[:user_id])

          render status: 404, json: { error: 'User not found'} unless @user
        end

        def set_address
          @address = @user.spree_addresses.find_by_id(params[:id])

          render status: 404, json: { error: 'Address not found'} unless @address
        end

        def address_params
          params.require(:address).permit(:firstname, :lastname, :address1, :address2, :city, :zipcode, :phone,
                                          :state_name, :alternative_phone, :company, :state_id, :country_id)
        end

        def respond_with_user_and_addresses(status)
          render status: status, json: {user: ecomm_user,
                                        owner_address: current_api_user.spree_addresses,
                                        ship_address: current_api_user.ship_address,
                                        bill_address: current_api_user.bill_address}
        end

      end
    end
  end
end