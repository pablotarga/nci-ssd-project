class RegisterController < ApplicationController
  before_action :require_anonymous_or_guests
  layout 'full'

  def new
    @person = Person.new
  end

  def create
    registration = RegistrationService.register(person_params)
    if registration.success?
      swap_cookie(registration.get(:user))
      redirect_to welcome_profile_path
    else
      redirect_to registration_path, alert: registration.errors
    end
  end

  private

  def person_params
    extract_params :person, permit: [:name, :email, :password]
  end
end
