module OrderMailers
  extend ActiveSupport::Concern

  included do
    # after_action :new_order_mail, only: [:create], if: -> { @order }
  end


  private

  def new_order_mail
    set_mail_attributes
    # Spree::OrderMailer.create_email(@order, @mail_attributes).deliver_later
  end

  def set_mail_attributes
    @mail_attributes ||= {
        site_name: Spree::Store.current.name,
        footer: 'Krissorbie',
        bg_img: '',
        header_img: false
    }
  end

end

