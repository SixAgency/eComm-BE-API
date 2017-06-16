Spree::UserMailer.class_eval do
  layout 'spree/base_mailer'

  def reset_password_instructions(user, token, *args)
      @edit_password_reset_url = EComm::Config.password_reset_link + token
      mail to: user.email, bcc: [], from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, :scope => [:devise, :mailer, :reset_password_instructions])
  end

  def create_active_user(user, password)
    @user = user
    @password = password
    @store = Spree::Store.current
    subject = Spree.t('user_mailer.create_active_user_email.subject', site_name: @store.name)
    mail(to: @user.email, from: @store.mail_from_address, subject: subject)
  end
end