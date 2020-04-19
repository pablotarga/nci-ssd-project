
# shopping cart
itemRow = $('#shopping-cart-item-<%= @order_item.id %>')
if <%= @deleted %>
  itemRow.remove()
else if itemRow
  newItemRow = $("<%= escape_javascript(render partial: 'item', object: @order_item) %>")
  itemRow.replaceWith(newItemRow)
$("#shopping-cart-total").text("<%= number_to_currency @total %>")

# add to cart buttons
newBtns = $("<%= escape_javascript(render partial: 'shared/product_cart_button', locals: {product: @order_item.product}) %>")
$('.product-cart-button-<%= @order_item.product_id %>').replaceWith(newBtns)

# cart widget
cartWidget = $('#cart-widget')
cartWidget.find('.amount').text("<%= @quantity %>")
cartWidget.find('.total').text("<%= number_to_currency @total %>")
if <%= @quantity %> > 0 then cartWidget.addClass('active') else cartWidget.removeClass('active')
