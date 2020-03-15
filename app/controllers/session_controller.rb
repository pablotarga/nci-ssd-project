class SessionController < ApplicationController

  def create
    # @user = Person.find_by(email: params[:email])
    # @user = @user.authenticate(params[:password])
    @user = User.first

    if @user.present?
      cookies[:user_id] = {
        value: @user.id,
        expires: 1.year,
        httponly: true
      }
    end

    redirect_to :root
  end

  def destroy
    cookies.delete :user_id
    redirect_to :root
  end
end
