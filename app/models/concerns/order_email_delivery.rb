module OrderEmailDelivery
  def deliver_order_confirmation_email
    Spree::OrderMailer.confirm_email(id).deliver_later
    Spree::OrderMailer.confirm_email(id, false, true).deliver_later
    update_column(:confirmation_delivered, true)
  end

  def send_cancel_email
    Spree::OrderMailer.cancel_email(id).deliver_later
    Spree::OrderMailer.cancel_email(id, false, true).deliver_later
  end
end