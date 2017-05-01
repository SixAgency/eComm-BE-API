module PartialAddresses
  extend ActiveSupport::Concern

  included do
    clear_validators!
    
    with_options presence: true, unless: :partial do
      validates :firstname, :lastname, :address1, :city, :country
      validates :zipcode, if: :require_zipcode?
      validates :phone, if: :require_phone?
    end
    
    validate :state_validate, :postal_code_validate
  end
end
