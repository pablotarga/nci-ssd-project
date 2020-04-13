class SessionController < ApplicationController
  before_action :require_anonymous_or_guests, except: [:destroy]
  layout 'full'

  def new
    cookies[:redirect_to] = URI.unescape(params[:redirect_to]) if params[:redirect_to].present?
    @person = Person.new
  end

  def create
    authentication = auth.by_email_and_password(**login_params)
    if authentication.success?
      swap_cookie(authentication)
      redirect_to get_path_after_login
    else
      redirect_to new_login_path, alert: t('errors.invalid_credentials')
    end
  end

  def destroy
    current_user.destroy if current_user.is_a?(Guest)

    cookies.delete :user_id
    redirect_to root_path, notice: t('notices.logout')
  end

  private

  def login_params
    extract_params :person, permit: [:email, :password]
  end
end
