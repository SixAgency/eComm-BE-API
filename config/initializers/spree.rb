# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
end

Spree.user_class = "Spree::User"

class ECommConfiguration < Spree::Preferences::Configuration
  preference :asset_host, :string, default: Figaro.env.asset_host
end

EComm::Config = ECommConfiguration.new

Spree::Ability.register_ability(LocationOwnerAbility)

#../gems/spree/core/lib/spree/permitted_attributes.rb - to let edit
Spree::PermittedAttributes.user_attributes.push :f_name, :l_name
Spree::PermittedAttributes.address_attributes.push :user_id
Spree::PermittedAttributes.product_attributes.push :max_quantity_allowed_in_cart
Spree::PermittedAttributes.checkout_attributes.push :line_item_attributes, :ship_address, :bill_address

# ..gems/spree/api/app/helpers/spree/api/api_helpers.rb to let show
Spree::Api::ApiHelpers.user_attributes.push :f_name, :l_name
Spree::Api::ApiHelpers.product_attributes.push :max_quantity_allowed_in_cart
