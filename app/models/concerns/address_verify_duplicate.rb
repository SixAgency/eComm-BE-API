module AddressVerifyDuplicate
  extend ActiveSupport::Concern

  included do
    validate :verify_duplicate, on: [:create, :update]
    @@current_api_user = nil

    def self.set_current_api_user(user)
      @@current_api_user ||= user
    end
  end


  private

  def verify_duplicate
    if user_id.present? && similar_resource_exists?
      errors.add(:base, 'Not a unique user address!')
    end
  end

  def similar_resource_exists?
    Spree::Address
        .where(attributes.except('id', 'updated_at', 'created_at'))
        .where(user_id: @@current_api_user).any?
  end
end