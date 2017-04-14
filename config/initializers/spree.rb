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

config = Rails.application.config
config.spree.calculators.promotion_actions_create_item_adjustments << Spree::Calculators::Sale
config.spree.promotions.rules                                      << Spree::Promotion::Rules::Sale


Spree.user_class = "Spree::User"

class ECommConfiguration < Spree::Preferences::Configuration
  preference :asset_host, :string, default: Figaro.env.asset_host
  preference :password_reset_link, :string, default: Figaro.env.password_reset_link
  preference :order_link, :string, default: Figaro.env.order_link
end

EComm::Config = ECommConfiguration.new

Spree::Ability.register_ability(LocationOwnerAbility)

#../gems/spree/core/lib/spree/permitted_attributes.rb - to let edit
Spree::PermittedAttributes.user_attributes.push :f_name, :l_name
Spree::PermittedAttributes.address_attributes.push :user_id, :user_address_id
Spree::PermittedAttributes.product_attributes.push :max_quantity_allowed_in_cart, :sale

Spree::PermittedAttributes.checkout_attributes.push :line_item_attributes,
                                                    :ship_address, :bill_address
Spree::PermittedAttributes.source_attributes.push :nonce

# ..gems/spree/api/app/helpers/spree/api/api_helpers.rb to let show
Spree::Api::ApiHelpers.user_attributes.push :f_name, :l_name
Spree::Api::ApiHelpers.product_attributes.push :max_quantity_allowed_in_cart, :sale, :is_sale
Spree::Api::ApiHelpers.variant_attributes.push :max_quantity_allowed_in_cart, :sale, :is_sale
Spree::Api::ApiHelpers.address_attributes.push :user_address_id

# In order to run guest user that don't require an API key
Spree::Api::Config[:requires_authentication] = false

# Merges users orders to their account after sign in and sign up.
Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  # API flow - json request
  if auth.params[:guest_token].present?
    if user.is_a?(Spree::User)
      Spree::Order.incomplete.where(guest_token: auth.params[:guest_token], user_id: nil).each do |order|
        order.associate_user!(user)
      end
    end
  end

  # HTML flow - html request
  if auth.cookies.signed[:guest_token].present?
    if user.is_a?(Spree::User)
      Spree::Order.incomplete.where(guest_token: auth.cookies.signed[:guest_token], user_id: nil).each do |order|
        order.associate_user!(user)
      end
    end
  end
end

Devise.secret_key = Figaro.env.SECRET_KEY_BASE
