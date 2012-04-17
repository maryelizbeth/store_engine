module ApplicationHelper
  def cart_nav_label
    "<div id=\"cart_info\">Cart (#{@cart.quantity} | #{number_to_currency(@cart.total)})</div>".html_safe
  end
  
  def display_order_special_url(order)
    orders_lookup_url(:sid => order.special_url)
  end
end
