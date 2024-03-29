module Spree
  module Api
    module V1
      class UserAddressesController < Spree::Api::BaseController
        load_and_authorize_resource :class => Address, except: [:index, :create]

        before_action :resource, only: [:show, :update, :destroy]

        ADDRESS_TYPE = %w(bill ship)

        def index
          respond_with_resource 200
        end
        
        def create
          @address = current_api_user.spree_addresses.new(resource_params)

          if @address.save
            set_default_resource

            render status: 201, json: { address: @address }
          else
            render status: 422, json: { errors: @address.errors }
          end
        end

        def show
          render status: 200, json: { address: resource }
        end

        def update
          if resource.update_attributes(resource_params)
            set_default_resource

            render status: 200, json: { address: resource }
          else
            render status: 422, json: { errors: @address.errors }
          end
        end

        def destroy
          resource.destroy
          delete_default_resources
          render status: 204, json: {}
        end

        def default_resources
          if exists_user_resources?
            set_default_resources
            render status: 200, json: { default_addresses: new_default_resources }, except: [:user_id]
          else
            respond_not_found
          end

        end

        private

        def resource
          @address ||= current_api_user.spree_addresses.find_by_id(params[:id])
        end

        def resource_params
          params.require(:address).permit(:firstname, :lastname, :address1, :address2, :city, :zipcode, :phone,
                                          :state_name, :alternative_phone, :company, :state_id, :country_id)
        end

        def respond_with_resource(status)
          render status: status, json: { owner_address: current_api_user.spree_addresses,
                                         ship_address: current_api_user.ship_address,
                                         bill_address: current_api_user.bill_address }
        end

        def respond_not_found
          render status: 404, json: { error: 'Address not found'}
        end

        # update resource and also default resource in User model
        def set_default_resource
          return unless params[:default_address_types]
          current_api_user.bill_address_id = resource.id if params[:default_address_types].include?('bill_address')
          current_api_user.ship_address_id = resource.id if params[:default_address_types].include?('ship_address')
          current_api_user.save
        end

        # update only the default resources
        def set_default_resources
          ADDRESS_TYPE.each do |type|
            @type = type
            set_default_new_resource
          end
          current_api_user.save
        end

        def set_default_new_resource
          return unless default_resource_params

          change_user_with_default_resource default_resource_params[:id]
        end

        def change_user_with_default_resource(id)
          current_api_user.send "#{@type}_address_id=", id
        end

        def exists_user_resources?
          ADDRESS_TYPE.map do |type|
            @type = type
            exists_user_resource?
          end.all? { |res| res == true }
        end

        def exists_user_resource?
          return true unless default_resource_params # escape when not needed
          resource_id = default_resource_params[:id]
          current_api_user.spree_addresses.find_by_id(resource_id) ? true : false
        end

        def default_resource_params
          params["default_#{@type}_address"]
        end

        def new_default_resources
          {
              bill_address: current_api_user.bill_address,
              ship_address: current_api_user.ship_address
          }
        end

        #TODO Daniel: must refactor this method
        def delete_default_resources
          must_save = false
          if current_api_user.ship_address_id = resource.id
            current_api_user.ship_address_id = nil
            must_save = true
          end

          if current_api_user.bill_address_id = resource.id
            current_api_user.bill_address_id = nil
            must_save = true
          end

          current_api_user.save if must_save
        end
      end
    end
  end
end