module Leader
  class BaseController < ApplicationController
    # before_action :authenticate_user!, :authorize_manager!

    private ##

    def authorize_leader!
      authorize(:access, :leader?)
    end
  end
end
