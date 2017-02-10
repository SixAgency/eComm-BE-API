module CheckoutAddresses
  extend ActiveSupport::Concern

  included do
    before_action :set_addresses, only: [:update]
    after_action :add_users_addresses, :set_default_address_for_user, only: [:update]
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
      user_address_id_from_params(type)

      # remove id and user_id from address params (let create only a snapshot for order)
      params[:order]["#{type}_address_attributes"].delete_if { |k, v| k == "user_id" || k == "id" }
      true
    else

      # set new address for user with user_id but not let duplicate address when are the same
      unless address_created?(type)
        create_address(type)
      end
    end
  end

  def address_params(type)
    params.require(:order).permit("#{type}_address_attributes".to_sym => [
        :firstname, :lastname, :address1, :address2, :city, :zipcode, :phone,
        :state_id, :country_id, :user_id, :company, :alternative_phone
    ])
  end

  def create_address(type)
    new_address = Spree::Address.new(address_params(type)["#{type}_address_attributes"].except('id', 'updated_at', 'created_at'))
    new_address.user_id = current_api_user.id

    if new_address.save
      new_user_address_id(type, new_address)
    else
      render status: 422, json: { errors: new_address.errors }
    end

    @created_address = new_address if same_both_address?
  end

  def same_both_address?
    params[:order][:bill_address_attributes] == params[:order][:ship_address_attributes]
  end

  def address_created?(type)
    Spree::Address::set_current_api_user(current_api_user)

    @created_address = Spree::Address
                                 .where(address_params(type)["#{type}_address_attributes"].except('id', 'updated_at', 'created_at'))
                                 .where(user_id: current_api_user.id).first
    new_user_address_id(type, @created_address) if @created_address

    @created_address
  end

  def add_users_addresses
    initial_response = JSON.parse(response.body)
    initial_response['ship_address']['selected_address_id'] = @user_ship_address_id || @created_address
    initial_response['bill_address']['selected_address_id'] = @user_bill_address_id || @created_address
    response.body = JSON.generate(initial_response, quirks_mode: true)
  end

  def user_address_id_from_params(type)
    @user_bill_address_id ||= params[:order]["#{type}_address_attributes"][:id] if type == :bill
    @user_shipp_address_id ||= params[:order]["#{type}_address_attributes"][:id] if type == :ship
  end

  def new_user_address_id(type, new_address)
    @user_bill_address_id ||= new_address.id if type == :bill
    @user_ship_address_id ||= new_address.id if type == :ship
  end

  def set_default_address_for_user
    current_api_user.bill_address_id = @user_bill_address_id
    current_api_user.ship_address_id = @user_ship_address_id
    current_api_user.save
  end

end