class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.find_by(id: cookies[:user_id]) if cookies[:user_id].present?
  end
  helper_method :current_user

  private

  def auth
    @auth ||= AuthService.new(request)
  end

  def extract_params base, permit: [], fallback: {}
    params.require(base).permit(permit).to_h.symbolize_keys rescue fallback
  end

  def require_any_user
    redirect_to root_path unless current_user.is_a?(User)
  end

  def require_anonymous_or_guests
    redirect_to root_path unless current_user.blank? || current_user.is_a?(Guest)
  end

end
