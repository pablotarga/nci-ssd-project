
list = document.getElementById("product_list")
list.innerHTML = "<%= escape_javascript(render partial: 'product', collection: @products) %>"
