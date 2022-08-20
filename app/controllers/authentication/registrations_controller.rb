module Authentication
  class RegistrationsController < Devise::RegistrationsController
    include Cleanable

    before_action :configure_permitted_parameters

    protected

    def account_update_params
      cleanup_uploaded_params(super, %i[avatar])
    end

    def after_update_path_for(_resource)
      sign_in_after_change_password? ? edit_user_registration_path : new_session_path(resource_name)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
    end
  end
end
