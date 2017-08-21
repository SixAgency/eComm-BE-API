Spree::User.send :include, UserHasApiToken, UserHasAddresses

Spree::User.class_eval do
  has_one :square_customer, as: :owner
  has_many :store_credit_events, through: :store_credits

  def full_name
  	return [self.f_name, self.l_name].join(" ").strip
  end
end
