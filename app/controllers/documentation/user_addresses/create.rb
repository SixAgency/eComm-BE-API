module Documentation
  module UserAddresses
    module Create
      extend ActiveSupport::Concern

      included do
        swagger_api :create do
          summary "Creates a new User Address"
          param :address, :firstname, :string, :required, "First name"
          param :address, :lastname, :string, :required, "Last name"
          param :address, :address1, :string, :required, "Address 1"
          param :address, :address2, :string, false, "Address 2"
          param :address, :city, :string, :required, "City"
          param :address, :zipcode, :string, :required, "Zipcode"
          param :address, :phone, :string, false, "Phone"
          param :address, :company, :string, false, "Company Name"
          param :address, :state_id, :string, :required, "State ID"
          param :address, :country_id, :string, :required, "Country ID"
          param_list :root, :default_address_types, :string, false, "Address type(s)", ["bill_address", "ship_address"]
          response 201, "Address created", "Spree::Address"
          response 422, "Address errors"
        end
      end
    end
  end
end

