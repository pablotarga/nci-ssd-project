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
    return fail!(errors: :product_not_found) unless product.present?

    # get the order item for that product, if not included initialize a new OrderItem
    order_item = cart.order_items.where(product: product).first_or_initialize

    # add current quantity if increment is true
    quantity += order_item.quantity.to_i if increment
    return remove_item(product_or_id, order_item: order_item) if quantity <= 0

    return fail!(order_item) unless order_item.update_attributes(quantity: quantity)

    success!(order_item: order_item, product: product)
  end

  def remove_item(id, order_item:nil)
    # no need to check if product exists, can be an clean up action after the product destruction

    # extract the id if product informed
    id = id.id if id.is_a?(Product)

    # get the first occurency on the db
    order_item = cart.order_items.where(product_id: id).first

    # destroy if found
    order_item.destroy if order_item

    success!(:item_removed, order_item: order_item)
  end

  def checkout(params)
    return fail!(errors: :must_be_person_to_checkout) unless user.is_a?(Person)
    return fail!(errors: :cannot_checkout) unless cart.can_checkout?
    check = checkstock
    return check unless check.success?

    # return fail!(errors: 'Address required') unless address_pass(params).success?

    stripe_token = params.delete :stripe_token
    return fail!(errors: :payment_token_required) unless stripe_token.present?

    payment = pay(stripe_token, total: cart.calculate_total)
    return payment unless payment.success?

    cart.update_attributes(status: :accepted, total: payment.get(:total), **params)

    cart.order_items.each do |item|
      item.product.update_attribute(:quantity, item.product.quantity - item.quantity)
      item.update_attribute(:total, item.product.price * item.quantity)
    end

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
      return fail!(errors: I18n.t('errors.product_out_of_stock', title: item.product.title), item: item) if item.quantity > item.product.quantity
    end
    success!
  end

  def pay(token, total: nil)
    total ||= cart.total
    Stripe.api_key = Rails.application.credentials.stripe[:secret_key]

    begin
      charge = Stripe::Charge.create({
        amount: (total*100).to_i,
        currency: 'eur',
        source: token,
        description: 'Order number #'+cart.id,
      })
      success!(charge: charge, total: total)
    rescue Stripe::CardError => e
      fail!(errors: e.error.message)
    end


  end


  def revert_checkout!
    cart.order_items.each do |item|
      item.product.update_attribute(:quantity, item.product.quantity + item.quantity)
      item.update_attribute(:total, nil)
    end

    cart.update_attributes(status: :pending, total: nil)

    success!
  end

end
