Spree::User.class_eval do

    before_validation :add_spree_token

    private

    def set_api_token
      self.spree_api_key ||= SecureRandom.hex(24)
    end

end