module OrderAddresses
  extend ActiveSupport::Concern

  included do
    before_action :set_addresses, only: [:update]
  end

  private

  def set_addresses
    @created_address = nil
    set_address :bill if params[:order][:bill_address_attributes]
    set_address :ship if params[:order][:ship_address_attributes]
  end

  def set_address(type)
    address_user_id = params[:order]["#{type}_address_attributes"][:user_id]

    if address_user_id && address_user_id.to_i == current_api_user.id

      # remove id and user_id from address params (let create only a snapshot for order)
      params[:order]["#{type}_address_attributes"].delete_if { |k, v| k == "user_id" || k == "id" }
      true
    else

      # set new address for user with user_id but not let duplicate address when are the same
      create_address(type) unless address_created?(type)
    end
  end

  def address_params(type)
    params.require(:order).permit("#{type}_address_attributes".to_sym => [
        :firstname, :lastname, :address1, :address2, :city, :zipcode, :phone,
        :state_id, :country_id, :user_id, :company, :alternative_phone
    ])
  end

  def create_address(type)
    address_type = Spree::Address.new(address_params(type)["#{type}_address_attributes"])
    address_type.user_id = current_api_user.id

    unless address_type.save
      render status: 422, json: { errors: address_type.errors }
    end

    @created_address = true if same_both_address?
  end

  def same_both_address?
    params[:order][:bill_address_attributes] == params[:order][:ship_address_attributes]
  end

  def address_created?(type)
    @created_address || Spree::Address
                                 .where(address_params(type)["#{type}_address_attributes"].except('id', 'updated_at', 'created_at'))
                                 .where(user_id: current_api_user.id).any?
  end
end