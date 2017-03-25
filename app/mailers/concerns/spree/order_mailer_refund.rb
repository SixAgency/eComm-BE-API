module Spree::OrderMailerRefund
  extend ActiveSupport::Concern

  def refund_email(refund)
    @order = refund.payment.order
    @store = Spree::Store.current
    subject = Spree.t('order_mailer.refund_email.subject', site_name: @store.name)
    mail(to: @order.email, from: @store.name, subject: subject)
  end
end