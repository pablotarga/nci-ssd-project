module ApplicationHelper
  def navbar_link(icon, title, url)
    link_to content_tag(:i, nil, class: icon), url, title: title
  end

  def in_shopping_cart?(product)
    return false unless current_user.present?
    get_product_amount(product) > 0
  end

  def get_product_amount(product)
    @get_shopping_cart_item ||= current_user.orders.pending.first
    return 0 unless @get_shopping_cart_item.present?
    @get_shopping_cart_items ||= @get_shopping_cart_item.order_items.map{|item| [item.product_id.to_s, item.quantity]}.to_h
    @get_shopping_cart_items[product.id.to_s].to_i
  end

end
