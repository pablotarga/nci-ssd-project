module ApplicationHelper
  def navbar_link(icon, title, url)
    link_to content_tag(:i, nil, class: icon), url, title: title
  end

  def has_shopping_cart?
    shopping_cart.present?
  end

  def shopping_cart_total
    has_shopping_cart? ? shopping_cart.calculate_total : 0
  end

  def shopping_cart_total_quantity
    has_shopping_cart? ? shopping_cart.order_items.sum(:quantity) : 0
  end

  def shopping_cart
    return @shopping_cart if current_user.blank? || @shopping_cart_checked
    @shopping_cart_checked = true
    @shopping_cart ||= current_user.orders.pending.first
  end

  def in_shopping_cart?(product)
    return false unless current_user.present?
    get_product_amount(product) > 0
  end

  def get_product_amount(product)
    return 0 unless has_shopping_cart?
    @get_shopping_cart_items ||= shopping_cart.order_items.map{|item| [item.product_id.to_s, item.quantity]}.to_h
    @get_shopping_cart_items[product.id.to_s].to_i
  end

end
