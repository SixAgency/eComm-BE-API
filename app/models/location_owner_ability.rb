class LocationOwnerAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Spree::User.new

    unless user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
      can [:read, :update, :destroy], Spree::Address, user_id: user.id
    end
  end
end