module AddressVerifyDuplicate
  extend ActiveSupport::Concern

  included do
    validate :verify_duplicate, on: [:create, :update]
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
        .where(user_id: user_id)
        .where.not(id: self.id).any?
  end
end