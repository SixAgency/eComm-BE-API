module CheckDeviseAuthorization
  extend ActiveSupport::Concern

  included do
    skip_before_filter :verify_authenticity_token, only: [:create], if: :api_request?
    prepend_before_action :unauthorize_logged_user, only: [:create], if: :api_request?
  end

  private

  def api_request?
    request.content_type =~ /json/
  end

  def unauthorize_logged_user
    respond_to do |format|
      format.json {
        render status: 401, json: { errors: 'User already logged in'}
      }
    end if spree_current_user
  end
end