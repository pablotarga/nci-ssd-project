class ApplicationController < ActionController::Base


  def current_user
    return unless cookies[:user_id].present?

    @current_user ||= User.find_by(id: cookies[:user_id])
  end
  helper_method :current_user
end
