module Authentication
  class SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(_resource)
      leader_root_path
    end
  end
end
