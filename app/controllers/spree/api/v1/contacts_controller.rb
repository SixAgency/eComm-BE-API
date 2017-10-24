class Spree::Api::V1::ContactsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    contact_email
  end

  private

  def contact_email
    set_mail_attributes
    Spree::ContactMailer.contact(@mail_attributes).deliver_later
    render status: 204, json: {}
  end


  def set_mail_attributes
    @mail_attributes ||= params[:contact].to_hash
  end
end
