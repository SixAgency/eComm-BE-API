Spree::OrderMailer.class_eval do
  def create_email(order, mail_attributes)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    @mail_attributes = mail_attributes
  end
end
