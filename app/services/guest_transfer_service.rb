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
    # return success if guest dont have any orders
    return success! unless guest.orders.pending.exists?

    if person.order.pending.exists?
      ShoppingCartService.new(person).copy(guest.orders.pending.pluck(:id))
      return success!(copied: true)
    else
      # simply transfer the orders from guest to person if person do not have shopping cart
      guest.orders.pending.update_all(user_id: person.id)
      return success!(transfered: true)
    end

  end

  def transfer_watchlists!
    # guest.watchlists.update_all(user_id: person.id)
  end

  def destroy_guest
    guest.orders.destroy_all
    guest.destroy
  end
end
