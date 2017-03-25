Spree::UserRegistrationsController.class_eval do
  include CheckDeviseAuthorization

  def create
    @user = build_resource(spree_user_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      Spree::UserMailer.create_active_user(resource, spree_user_params[:password]).deliver_later

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
          render status: 409, json: {errors: resource.errors.messages, email: resource.email}
        end

        format.html { render :new }
      end
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end

      sign_in resource_name, resource, bypass: true

      respond_to do |format|
        format.json {
          render :json => {:message => "User was updated successfully"}
        }

        format.html {
          respond_with resource, location: after_update_path_for(resource)
        }
      end

    else
      clean_up_passwords resource

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
