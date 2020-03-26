class UserTransferService < ApplicationService
  attr_reader :origin, :target
  def initialize(origin, target)
    @origin = origin if origin.is_a?(Guest)
    @target = target if target.is_a?(Person)
  end

  def transfer(destroy: true)
    return false unless origin.present? && target.present?
    transfer_orders!
    transfer_watchlists!

    destroy_guest if destroy
  end

  private

  def transfer_orders!
    # return success if origin dont have any orders
    return success! unless origin.orders.pending.exists?

    if target.order.pending.exists?
      ShoppingCartService.new(target).copy(origin.orders.pending.pluck(:id))
      return success!(copied: true)
    else
      # simply transfer the orders from origin to target if target do not have shopping cart
      origin.orders.pending.update_all(user_id: target.id)
      return success!(transfered: true)
    end

  end

  def transfer_watchlists!
    # origin.watchlists.update_all(user_id: target.id)
  end

  def destroy_guest
    origin.orders.destroy_all
    origin.destroy
  end
end
