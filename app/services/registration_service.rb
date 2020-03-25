class RegistrationService < ApplicationService

  def self.register(params)
    user = Person.new(params)

    return fail!(user) unless user.save
    success!(user: user)
  end

end
