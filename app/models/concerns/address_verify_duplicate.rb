module AddressVerifyDuplicate
  extend ActiveSupport::Concern

  included do
    validate :verify_duplicate
  end

  def verify_duplicate
    if user_id.present? && Spree::Address.where(attributes.except('id', 'updated_at', 'created_at')).any?
      errors.add(:base, 'Not a unique user address!')
    end
  end
end