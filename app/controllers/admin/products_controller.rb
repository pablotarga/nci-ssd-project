class Admin::ProductsController < AdminController

  def index
    @product = Product.all
  end

end
