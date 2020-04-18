class Admin::OrderPaymentsController < AdminController
  before_action :require_payment

  def destroy
    refunding = ShoppingCartService.refund(payment)
    if refunding.success?
      redirect_to edit_admin_order(order), notice: t('notices.refunded_with_success')
    else
      redirect_to edit_admin_order(order), alert: refunding.errors
    end
  end


  private

  def require_payment
    return if payment.present?

    if order.present?
      redirect_to edit_admin_order(order), alert: t('errors.not_found')
    else
      redirect_to admin_orders_path, alert: t('errors.not_found')
    end
  end

  def order
    @order ||= Order.where(id: params[:order_id]).first
  end

  def payment
    @payment ||= order.payments.where(id: params[:id]).first if order.present?
  end

end
