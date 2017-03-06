class LocationOwnerAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Spree::User.new

    can [:read, :update, :destroy, :default_resources], Spree::Address, user_id: user.id


    # if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
    #   can [:display], Spree::Address, user_id: user.id
    # end

  end
end