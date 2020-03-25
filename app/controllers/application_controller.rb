class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.find_by(id: cookies[:user_id]) if cookies[:user_id].present?
  end
  helper_method :current_user

  private

  def swap_cookie(auth_or_user)
    # in case of registration auth_or_user will be a user, from session_controller we get authentication (result of by_email_and_password)
    authentication = auth_or_user.is_a?(Person) ? auth.by_user(auth_or_user) : auth_or_user

    # at this point we normalized the response and authentication is the result of auth.by_user
    # we check if current user is a Guest we must transfer the data into the Person
    UserTransferService.new(current_user, authentication.get(:user)).transfer if current_user.is_a?(Guest)

    @current_user = authentication.get(:user)
    cookies[:user_id] = authentication.get(:cookie)
  end


  def auth
    @auth ||= AuthService.new(request)
  end

  def extract_params base, permit: [], fallback: {}
    params.require(base).permit(permit).to_h.symbolize_keys rescue fallback
  end

  def require_person
    redirect_to root_path unless current_user.is_a?(Person)
  end

  def require_any_user
    redirect_to root_path unless current_user.is_a?(User)
  end

  def require_anonymous_or_guests
    redirect_to root_path unless current_user.blank? || current_user.is_a?(Guest)
  end

end
