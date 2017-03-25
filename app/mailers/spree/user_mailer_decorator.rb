Spree::UserMailer.class_eval do
  layout 'spree/base_mailer'

  def create_active_user(user, password)
    @user = user
    @password = password
    @store = Spree::Store.current
    subject = Spree.t('user_mailer.create_active_user_email.subject', site_name: @store.name)
    mail(to: @user.email, from: @store.mail_from_address, subject: subject)
  end
end