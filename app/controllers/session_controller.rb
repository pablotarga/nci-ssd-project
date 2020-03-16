class SessionController < ApplicationController
  layout 'full'

  def new
    @person = Person.new
  end

  def create
    if auth.by_email_and_password(**login_params)
      cookies[:user_id] = auth.cookie_data
      redirect_to root_path, notice: 'You are in!'
    else
      redirect_to new_login_path, alert: 'Invalid credentials'
    end
  end

  def destroy
    cookies.delete :user_id
    redirect_to root_path, notice: 'Logged out!'
  end

  private

  def auth
    @auth ||= AuthService.new(request)
  end

  def login_params
    extract_params :person, permit: [:email, :password]
  end
end
