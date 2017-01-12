module OrderEmailDelivery
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      def deliver_order_confirmation_email
        Spree::OrderMailer.confirm_email(id).deliver_later
        Spree::OrderMailer.confirm_email(id, false, true).deliver_later
        update_column(:confirmation_delivered, true)
      end
    end
  end

end