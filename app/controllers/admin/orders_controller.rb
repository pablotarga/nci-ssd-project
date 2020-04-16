class Admin::OrdersController < AdminController
  before_action :order_required!, only: [:edit, :update]

  def index
    @orders = Order.all
  end

  def edit
  end

  def update
    if order.update_attributes(update_params)
      redirect_to admin_orders_path, notice: t('notices.saved_with_success')
    else
      flash[:alert] = order.errors.full_message
      render 'edit'
    end
  end

  private

  def order
    @order ||= Order.where(id: params[:id]).first
  end

  def update_params
    extract_params :order, permit:[:status]
  end

  def order_required!
    redirect_to(admin_orders_path, alert: t('error.not_found')) unless order.present?
  end

end
