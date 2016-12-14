Spree::UserSessionsController.class_eval do
  skip_before_filter :verify_authenticity_token, only: [:create], if: :api_request?
  prepend_before_action :authorize_login, only: [:create], if: :api_request?

  def create
    authenticate_spree_user!

    if spree_user_signed_in?
      respond_to do |format|
        format.json {
          render :json => {:user => {email: spree_current_user.email, spree_api_key: spree_current_user.spree_api_key},
                           :ship_address => spree_current_user.ship_address,
                           :bill_address => spree_current_user.bill_address}
        }

        format.html {
          flash[:success] = Spree.t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        }

        format.js {
          render :json => {:user => spree_current_user,
                           :ship_address => spree_current_user.ship_address,
                           :bill_address => spree_current_user.bill_address}.to_json
        }
      end
    else
      respond_to do |format|
        format.json {
          render :json => { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        }

        format.html {
          flash.now[:error] = t('devise.failure.invalid')
          render :new
        }

        format.js {
          render :json => { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        }
      end
    end
  end

  #TODO Daniel: Refactor bellow methods (DRY) - see user_reigstrations_controller_decorator.rb
  private

  def api_request?
    request.content_type =~ /json/
  end

  def authorize_login
    respond_to do |format|
      format.json {
        render status: 401, json: { errors: 'User already logged in' }
      }
    end if spree_current_user
  end
end
