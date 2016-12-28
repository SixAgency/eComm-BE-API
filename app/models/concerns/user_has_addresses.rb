module UserHasAddresses
  extend ActiveSupport::Concern

  included do
    has_many :spree_addresses, class_name: 'Spree::Address'
  end
end