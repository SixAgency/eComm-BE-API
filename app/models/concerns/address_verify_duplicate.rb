module AddressVerifyDuplicate
  extend ActiveSupport::Concern

  included do
    validate :verify_duplicate
  end

  private

  def verify_duplicate
    if user_id.present? && similar_resource_exists?
      errors.add(:base, 'Not a unique user address!')
    end
  end

  def similar_resource_exists?
    old_resources = Spree::Address.where(attributes.except('id', 'updated_at', 'created_at'))
    old_resources.any? ? exists_one?(old_resources) : false
  end

  def exists_one?(old_resources)
    old_resources.map {|resource| resource.id != id && resource.user_id.present? }.include?(true)
  end

end