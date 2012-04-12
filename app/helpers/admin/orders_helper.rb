module Admin::OrdersHelper
  def display_status_transition_links(order)
    links = []
    actions = case order.status
      when "pending"  then ["process payment", "cancel"]
      when "paid"     then ["ship"]
      when "shipped"  then ["return"]
      else [] # nothing to do
    end
    actions.each { |action| links << create_status_transition_link(order, action) }
    links.join(" | ").html_safe
  end
  
  def create_status_transition_link(order, status)
    link_to(status.capitalize, admin_order_path(order, :transition => status.parameterize), :method => :put, :class => 'btn btn-mini')
  end
end
