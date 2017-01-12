Spree::OrderMailer.class_eval do
  def confirm_email(order, resend=false, to_internal=false)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    @to_internal = to_internal
    subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
    subject += "#{Spree::Store.current.name} #{Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
    target_email = @to_internal ? DefaultAppSettings::ORDER_EMAIL_TO : @order.email
    mail(to: target_email, from: from_address, subject: subject)
  end
end
