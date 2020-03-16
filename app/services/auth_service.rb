

class AuthService < ApplicationService
  attr_reader :request, :user
  def initialize(request=nil)
    @request = request # this will be used to register ip address, web browser client, ...
    @user = nil
  end

  def by_user(user)
    @user = user
  end

  def by_email_and_password(email:, password:)
    @user = nil

    user = Person.where(email: email).first
    return false unless user.present?

    user = user.authenticate(password)
    return false unless user.present?

    @user = user
  end

  def cookie_data
    CookieService.data(user)
  end
end
