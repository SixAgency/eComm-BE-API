Spree::UserRegistrationsController.class_eval do
  skip_before_filter :verify_authenticity_token, only: [:create], if: :api_request?
  before_action :authorize_register_user, only: [:create], if: :api_request?

  def create
    @user = build_resource(spree_user_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        session[:spree_user_signup] = true

        respond_to do |format|
          set_flash_message :notice, :signed_up
          format.json do
            render :json => { user: { email: resource.email, spree_api_key: resource.spree_api_key } }
          end

          format.html do
            respond_with resource, location: after_sign_up_path_for(resource)
          end

        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_to do |format|
          format.json {
            render :json => {:message => "You have signed up successfully but the user is inactive for the moment"}
          }

          format.html {
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          }
        end
      end
    else
      clean_up_passwords(resource)
      respond_to do |format|
        format.json do
          render status: 400, json: {errors: resource.errors.messages, email: resource.email}
        end

        format.html { render :new }
      end
    end
  end

  private

  def api_request?
    request.content_type =~ /json/
  end

  def authorize_register_user
    respond_to do |format|
      format.json {
        render status: 401, json: { errors: 'User already logged in'}
      }
    end if spree_current_user
  end
end
