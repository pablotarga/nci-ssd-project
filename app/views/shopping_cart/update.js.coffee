
itemRow = $('#shopping-cart-item-<%= @order_item.id %>')
if <%= @deleted %>
  itemRow.remove()
else if itemRow
  newItemRow = $("<%= escape_javascript(render partial: 'item', object: @order_item) %>")
  itemRow.replaceWith(newItemRow)

$("#shopping-cart-total").text("<%= number_to_currency @cart.calculate_total %>")
