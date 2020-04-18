class ProductsController < ApplicationController
  before_action :product_required

  def show
  end

  private

  def product
    @product ||= Product.where(id: params[:id]).first
  end

  helper_method :product

  def product_required
    redirect_to(root_path, alert: t('error.not_found')) unless product.present?
  end

end
