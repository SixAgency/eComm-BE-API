class Spree::GiftCardMailer < Spree::BaseMailer
  layout 'spree/base_mailer'

  def gift_card_email(gift_card)
    @gift_card = gift_card.respond_to?(:id) ? gift_card : Spree::VirtualGiftCard.find(gift_card)
    @order = @gift_card.line_item.order
    send_to_address = @gift_card.recipient_email.presence || @order.email
    subject = "#{Spree::Store.current.name} #{Spree.t('gift_card_mailer.gift_card_email.subject')}"
    mail(to: send_to_address, from: from_address, subject: subject)
  end

  def gift_redeemed_email(gift_card)
    @gift_card = gift_card.respond_to?(:id) ? gift_card : Spree::VirtualGiftCard.find(gift_card)
    @order = @gift_card.line_item.order
    subject = Spree.t('gift_card_mailer.gift_card_redeem_email.subject', recipient_name: @gift_card.recipient_name)
    mail(to: @order.email, from: from_address, subject: subject)
  end
end