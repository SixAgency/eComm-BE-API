Spree::User.class_eval do

    after_create :add_spree_token

    private

    def add_spree_token
      self.spree_api_key = SecureRandom.hex(24)
      self.save
    end

end