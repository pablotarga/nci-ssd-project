

class AuthService < ApplicationService
  attr_reader :request, :user
  def initialize(request=nil)
    @request = request # used by set_current_auth_info!
    @user = nil
  end

  def by_user(user)
    @user = user
    set_current_auth_info!
    success!(cookie: cookie_data, user: user)
  end

  def by_email_and_password(email:, password:)
    @user = nil

    user = Person.where(email: email).first
    return fail!(:not_found) unless user.present?

    user = user.authenticate(password)
    return fail!(:not_found) unless user.present?

    by_user(user)
  end

  def cookie_data
    CookieService.data(user)
  end

  private

  def set_current_auth_info!
    return unless user.is_a?(Person)

    user.last_auth_at = user.current_auth_at
    user.last_auth_ip = user.current_auth_ip
    user.current_auth_at = Time.now
    user.current_auth_ip = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip if request.present?
    user.save

    success!
  end


end
