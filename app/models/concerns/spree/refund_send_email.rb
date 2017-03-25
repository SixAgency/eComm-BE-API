module Spree::RefundSendEmail
  extend ActiveSupport::Concern

  included do
    after_create :send_customer_email
  end

  private

  def send_customer_email
    Spree::OrderMailer.refund_email(self).deliver_later
  end
end