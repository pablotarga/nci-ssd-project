class GuestTransferService < ApplicationService
  attr_reader :guest, :person
  def initialize(guest, person)
    @guest = guest if guest.is_a?(Guest)
    @person = person if person.is_a?(Person)
  end

  def transfer(destroy: true)
    return false unless guest.present? && person.present?
    transfer_orders!
    transfer_watchlists!

    destroy_guest if destroy
  end

  private

  def transfer_orders!
    # guest.orders.update_all(user_id: person.id)
  end

  def transfer_watchlists!
    # guest.watchlists.update_all(user_id: person.id)
  end

  def destroy_guest
    guest.destroy
  end
end
