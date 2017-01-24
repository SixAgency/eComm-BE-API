module Spree
  class ContactMailer < BaseMailer
    layout 'spree/base_mailer'

    def contact(mail_attributes)
      @mail_attributes = mail_attributes
      subject = @mail_attributes['subject'] ? @mail_attributes['subject'] : 'Message from krissorbie.com contact form'
      mail(to: DefaultAppSettings::DEFAULT_INFO_EMAIL, from: @mail_attributes['email'], subject: subject)
    end
  end
end
