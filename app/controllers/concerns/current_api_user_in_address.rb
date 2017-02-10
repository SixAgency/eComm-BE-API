module CurrentApiUserInAddress
  extend ActiveSupport::Concern

  included do
    before_action :current_api_user_in_address, on: :create
  end


  private

  def current_api_user_in_address
    Spree::Address::set_current_api_user(current_api_user)
  end
end

