Spree::UserPasswordsController.class_eval do
  skip_before_filter :verify_authenticity_token, only: [:create], if: :api_request?

    # Overridden due to bug in Devise.
  #   respond_with resource, :location => new_session_path(resource_name)
  # is generating bad url /session/new.user
  #
  # overridden to:
  #   respond_with resource, :location => spree.login_path
  #
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?

      respond_to do |format|
        format.json {
          render :json => { message: 'Reset password instructions was send', user: {email: resource.email} }
        }

        format.html {
          set_flash_message(:notice, :send_instructions) if is_navigational_format?
          respond_with resource, :location => spree.login_path
        }
      end

    else
      respond_to do |format|
        format.json {
          render :json => {:errors => resource.errors.full_messages}
        }

        format.html {
          respond_with_navigational(resource) { render :new }
        }
      end
    end
  end

  # Devise::PasswordsController allows for blank passwords.
  # Silly Devise::PasswordsController!
  # Fixes spree/spree#2190.
  def update
    if params[:spree_user][:password].blank?
      self.resource = resource_class.new
      resource.reset_password_token = params[:spree_user][:reset_password_token]
      respond_to do |format|
        format.json {
          render :json => {:errors => "Password can't be blank"}
        }

        format.html {
          set_flash_message(:error, :cannot_be_blank)
          render :edit
        }
      end
    else
      self.resource = resource_class.reset_password_by_token(resource_params)
      yield resource if block_given?

      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        if Devise.sign_in_after_reset_password
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message!(:notice, flash_message)
          sign_in(resource_name, resource)
        else
          set_flash_message!(:notice, :updated_not_active)
        end

        respond_to do |format|
          format.json {
            if Devise.sign_in_after_reset_password
              render :json => { :message => 'Password was changed and user is logged in',
                                :user => { :email => resource.email, :spree_api_key => resource.spree_api_key } }
            else
              render :json => {:message => 'Password was changed but user can not log in'}
            end
          }

          format.html {
            respond_with resource, location: after_resetting_password_path_for(resource)
          }
        end

      else
        set_minimum_password_length

        respond_to do |format|
          format.json {
            render :json => {:errors => resource.errors.full_messages}
          }

          format.html {
            respond_with resource
          }
        end
      end
    end
  end

  private

  def api_request?
    request.content_type =~ /json/
  end
end
