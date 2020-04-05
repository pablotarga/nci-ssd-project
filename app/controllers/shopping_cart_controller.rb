class ShoppingCartController < ApplicationController

  before_action :require_any_user

  def show
    @cart = service.cart
  end

  def update
    process = service.add_item(params[:product_id], update_params[:quantity], increment: update_params[:increment])
    if process.success?
      redirect_to shopping_cart_path, notice: "Item #{process.get(:product).try(:title)} updated!"
    else
      redirect_to shopping_cart_path, alert: "Oops, something went wrong!"
    end
  end

  def destroy
    process = service.remove_item(params[:product_id])
    redirect_to shopping_cart_path, notice: "Item removed!"
  end

  def checkout
    process = service.checkout
    if process.success?
      redirect_to root_path, notice: "Checkout complete"
    else
      redirect_to({action: :show}, alert: process.errors)
    end
  end

  private

  def service
    @service ||= ShoppingCartService.new(current_user)
  end

  def update_params
    extract_params :product, permit: [:quantity, :increment]
  end

end
