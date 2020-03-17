class RegistrationService < ApplicationService

  attr_reader :guest, :user
  def initialize(guest:nil)
    @guest = guest if guest.is_a?(Guest)
  end

  def register(params)
    @user = Person.new(params)
    return false unless user.save

    GuestTransferService.new(guest, user).transfer
    return true
  end

end
