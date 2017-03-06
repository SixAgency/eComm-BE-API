class SquareCustomer < ApplicationRecord
  belongs_to :owner, polymorphic: true

  class << self
    def from(order:)
      if order.user_id.present?
        return where(owner: order).first_or_create
      else
        return where(owner: order.user).first_or_create
      end
    end
  end
end