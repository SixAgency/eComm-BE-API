Spree::User.send :include, UserHasApiToken, UserHasAddresses

Spree::User.class_eval do
  has_one :square_customer, as: :owner
end
