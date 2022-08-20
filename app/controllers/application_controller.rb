class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  def self.only_turbo_stream_for(*actions)
    raise ArgumentError, 'force_turbo_stream_for arguments must have least one item' if actions.blank?

    before_action :ensure_turbo_frame_request, only: actions
  end

  def send_flash_message(message:, success: true, now: false)
    type = success ? :notice : :alert
    (now ? flash.now : flash)[type] = message
  end

  private

  def not_authorized
    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  def ensure_turbo_frame_request
    head :bad_request unless turbo_frame_request?
  end
end
