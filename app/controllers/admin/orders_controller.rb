class Admin::OrdersController < ApplicationController
  before_filter :require_admin
  
  ORDER_STATUSES = ["canceled", "paid", "pending", "returned", "shipped"]
  
  def index
    if params[:order_status] && ORDER_STATUSES.include?(params[:order_status])
      @orders = Order.find_all_by_status(params[:order_status])
      @selected_order_state = params[:order_status]
    else
      @orders = Order.all
    end  
    @order_statuses = ORDER_STATUSES
  end
  
  def show
    @order = Order.find(params[:id])
  end
  
  def update
    order = Order.find(params[:id])
    old_status = order.status
    order.transition(params[:transition])
    flash[:notice] = "Order successfully transtitioned from '#{old_status}' to '#{order.status}'"
    redirect_to admin_orders_path
  end
end
