module UserHasApiToken
  extend ActiveSupport::Concern

  included do
    before_validation :set_api_token
  end

  def set_api_token
    self.spree_api_key ||= generate_spree_api_key
  end
end