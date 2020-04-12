class Admin::ProductsController < AdminController
  before_action :product_required, only: [:edit, :update]

  def index
    @products = Product.all
  end

  def edit
  end

  def update
    if product.update_attributes(update_params)
      redirect_to admin_products_path, notice: t('notices.saved_with_success')
    else
      flash[:alert] = products.errors.full_message
      render 'edit'
    end
  end

  private

  def update_params
    _params = extract_params :product, permit: [:title, :description, :tag_list, :quantity, :price, :cost]
    _params
  end

  def product
    @product ||= Product.where(id: params[:id]).first
  end

  helper_method :product

  def product_required
    redirect_to(admin_products_path, alert: t('error.not_found')) unless product.present?
  end


end
