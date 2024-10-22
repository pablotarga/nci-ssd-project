class ShoppingCartController < ApplicationController

  before_action :create_guest, only: :update
  before_action :require_any_user
  before_action :ensure_cart_can_be_checked_out, only: [:pre_checkout, :checkout]

  def show
    @cart = service.cart
  end

  def update
    process = service.add_item(params[:product_id], update_params[:quantity], increment: update_params[:increment])
    if process.success?
      @deleted = process.item_removed?
      @cart = service.cart
      @total = @cart.calculate_total
      @quantity = @cart.order_items.sum(:quantity)
      @order_item = process.get(:order_item)
      respond_to do |format|
        format.js
        format.html {
          redirect_to shopping_cart_path, notice: t('notices.item_updated', title: process.get(:product).try(:title))
        }
      end

    else
      redirect_to shopping_cart_path, alert: t('errors.oops')
    end
  end

  def destroy
    process = service.remove_item(params[:product_id])
    redirect_to shopping_cart_path, notice: t('errors.item_removed')
  end

  def pre_checkout
    @cart = service.cart
  end

  def checkout
    process = service.checkout(checkout_params)
    if process.success?
      redirect_to thank_you_path, notice: t('notices.checkout_complete')
    else
      redirect_to({action: :pre_checkout}, alert: process.errors)
    end
  end

  private

  def service
    @service ||= ShoppingCartService.new(current_user)
  end

  def update_params
    extract_params :product, permit: [:quantity, :increment]
  end

  def checkout_params
    extract_params :order, permit: [
      :delivery_country,
      :delivery_administrative,
      :delivery_city,
      :delivery_address,
      :stripe_token
    ]
  end

  def create_guest
    return if current_user.present?
    swap_cookie(Guest.create)
  end

  def ensure_cart_can_be_checked_out
    redirect_to(shopping_cart_path, alert: t('errors.cannot_checkout')) unless service.cart.can_checkout?
  end

end
