class LocationOwnerAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Spree::User.new

    can [:read, :update, :destroy, :default_resources], Spree::Address, user_id: user.id
  end
end