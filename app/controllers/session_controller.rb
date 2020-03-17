class SessionController < ApplicationController
  before_action :require_anonymous_or_guests, except: [:destroy]
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
    current_user.destroy if current_user.is_a?(Guest)

    cookies.delete :user_id
    redirect_to root_path, notice: 'Logged out!'
  end

  private

  def login_params
    extract_params :person, permit: [:email, :password]
  end
end
