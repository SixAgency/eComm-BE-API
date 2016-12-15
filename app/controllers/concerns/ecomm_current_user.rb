module EcommCurrentUser
  extend ActiveSupport::Concern

  def ecomm_user
    @ecomm_user ||= { id: current_api_user.id,
                      email: current_api_user.email,
                      spree_api_key: current_api_user.spree_api_key }
  end
end