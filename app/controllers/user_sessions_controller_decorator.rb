Spree::UserSessionsController.class_eval do
  include CheckDeviseAuthorization

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
end
