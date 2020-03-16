class RegisterController < ApplicationController
  before_action :require_anonymous_or_guests
  layout 'full'

  def new
    @person = Person.new
  end

  def create
    if service.register(person_params)
      auth.by_user(service.user)
      cookies[:user_id] = auth.cookie_data
      redirect_to root_path, notice: 'You are in!'
    else
      redirect_to registration_path
    end
  end

  private

  def service
    @service ||= RegistrationService.new(guest: current_user)
  end

  def person_params
    extract_params :person, permit: [:name, :email, :password]
  end
end
