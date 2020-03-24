require 'test_helper'

class ShoppingCartServiceTest < ActiveSupport::TestCase
  test "should create a new shopping cart" do
    g = Guest.create
    assert_not g.orders.exists?

    ShoppingCartService.new(g)
    assert g.orders.exists?
  end

  test "should not duplicate shopping cart" do
    g = Guest.create
    g.orders.create!

    ShoppingCartService.new(g)
    assert_equal g.orders.count, 1
  end

  test "should allow to add products" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,1).success?
  end

  test "should create order item with product" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first
    adding = s.add_item(product,1)

    assert s.cart.order_items.first.product == product
  end

  test "should not duplicate products" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,1).success?
    assert s.add_item(product.id,10).success?
    assert_equal s.cart.order_items.count, 1
  end

  test "should set informed quantity to the item" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,1).success?
    assert_equal s.cart.order_items.first.quantity, 1

    assert s.add_item(product,10).success?
    assert_equal s.cart.order_items.first.quantity, 10
  end

  test "should increment informed quantity" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,1).success?
    assert_equal s.cart.order_items.first.quantity, 1

    assert s.add_item(product,10, increment: true).success?
    assert_equal s.cart.order_items.first.quantity, 11
  end

  test "should remove item if increment results in zero" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,5).success?
    assert_equal s.cart.order_items.first.quantity, 5

    assert s.add_item(product,-5, increment: true).success?
    assert_not s.cart.order_items.exists?
  end

  test "should remove item if increment results in a negative value" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,5).success?
    assert_equal s.cart.order_items.first.quantity, 5

    assert s.add_item(product,-6, increment: true).success?
    assert_not s.cart.order_items.exists?
  end

  test "should not create item if quantity is zero" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,0).success?
    assert_not s.cart.order_items.exists?
  end

  test "should remove item if quantity is zero" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,1).success?
    assert s.cart.order_items.exists?

    assert s.add_item(product,0).success?
    assert_not s.cart.order_items.exists?
  end

  test "should not change if quantity is zero and increment is informed" do
    s = ShoppingCartService.new(Guest.first_or_create)
    product = Product.first

    assert s.add_item(product,1).success?
    assert s.cart.order_items.exists?

    assert s.add_item(product,0, increment: true).success?
    assert s.cart.order_items.exists?
  end

  test "should allow to copy orders" do
    a = ShoppingCartService.new(Guest.create)
    b = ShoppingCartService.new(Guest.create)

    Product.limit(3).each do |product|
      assert a.add_item(product, 4).success?
    end

    assert_equal a.cart.order_items.count, 3
    assert_not b.cart.order_items.exists?
    assert b.copy(a.cart.id).success?
    assert_equal b.cart.order_items.count, 3
  end

  test "should increment when copying orders" do
    a = ShoppingCartService.new(Guest.create)
    b = ShoppingCartService.new(Guest.create)

    product = Product.first
    a.add_item(product, 4).success?
    b.add_item(product, 4).success?

    assert a.copy(b.cart.id).success?
    assert_equal a.cart.order_items.first.quantity, 8
  end

  test "should keep previous items when copying orders" do
    a = ShoppingCartService.new(Guest.create)
    b = ShoppingCartService.new(Guest.create)

    p1 = Product.first
    p2 = Product.last

    a.add_item(p1, 1).success?
    b.add_item(p2, 1).success?

    assert a.copy(b.cart.id).success?
    assert_equal a.cart.order_items.find_by(product_id: p1).quantity, 1
    assert_equal a.cart.order_items.find_by(product_id: p2).quantity, 1
  end

end
