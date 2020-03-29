class ShoppingCartController < ApplicationController

  before_action :require_any_user

  def show
    @cart = service.cart
  end

  private
  def service
    ShoppingCartService.new(current_user)
  end

end
