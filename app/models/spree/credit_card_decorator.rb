Spree::CreditCard.class_eval do
  alias_method :run_validations,  :imported
  alias_method :run_validations=, :imported=

  belongs_to :address, class_name: 'Spree::Address'
end
