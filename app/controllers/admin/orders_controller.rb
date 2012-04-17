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
    @order_count = {}
    @order_count[:pending] = Order.find_all_by_status("pending").count
    @order_count[:paid] = Order.find_all_by_status("paid").count
    @order_count[:shipped] = Order.find_all_by_status("shipped").count
    @order_count[:returned] = Order.find_all_by_status("returned").count
    @order_count[:canceled] = Order.find_all_by_status("canceled").count
    @order_statuses = ORDER_STATUSES
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @order = Order.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def update
    order = Order.find(params[:id])
    old_status = order.status
    order.transition(params[:transition])
    flash[:notice] = "Order successfully transtitioned from '#{old_status}' to '#{order.status}'"
    redirect_to admin_orders_path
  end
end
