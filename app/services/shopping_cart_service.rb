class ShoppingCartService < ApplicationService

  attr_reader :user, :cart
  def initialize(user)
    @user = user

    # get first pending order or create a new one if not found
    @cart = user.orders.pending.first_or_create!
  end

  def add_item(product_or_id, quantity, increment: false)
    quantity = quantity.to_i
    # if incrementing and quantity is zero, no actions to be made
    # if setting to zero (not incrementing) then we should call remove_item
    return (increment ? success!(:no_changes) : remove_item(product_or_id)) if quantity == 0

    # fetch product from db to make sure it exists, return fail if not found
    product = Product.fetch(product_or_id)
    return fail!(errors: 'Product not found') unless product.present?

    # get the order item for that product, if not included initialize a new OrderItem
    order_item = cart.order_items.where(product: product).first_or_initialize

    # add current quantity if increment is true
    quantity += order_item.quantity.to_i if increment
    return remove_item(product_or_id) if quantity <= 0

    return fail!(order_item) unless order_item.update_attributes(quantity: quantity)

    success!(order_item: order_item, product: product)
  end

  def remove_item(id)
    # no need to check if product exists, can be an clean up action after the product destruction

    # extract the id if product informed
    id = id.id if id.is_a?(Product)

    # get the first occurency on the db
    order_item = cart.order_items.where(product_id: id).first

    # destroy if found
    order_item.destroy if order_item

    success!
  end

  def checkout
    return fail!(errors: 'Unable to checkout') unless cart.can_checkout?
    check = checkstock
    return check unless check.success?
    total = 0
    cart.order_items.each do |item|
      item.product.update_attribute(:quantity, item.product.quantity - item.quantity)
      item.update_attribute(:total, item.product.price * item.quantity)
      total += item.total
    end
    cart.update_attributes(status: :waiting_payment, total: total)
    success!
  end

  def copy(*order_ids)
    order_ids = [order_ids].flatten.map(&:to_s)

    OrderItem.includes(:product).where(:order_id.in => order_ids).each do |i|
      add_item(i.product, i.quantity, increment: true)
    end

    success!
  end

  def checkstock
    cart.order_items.each do |item|
      return fail!(errors: "#{item.product.title} is out of stock", item: item) if item.quantity > item.product.quantity
    end
    success!
  end

end
