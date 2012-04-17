class OrdersController < ApplicationController
  
  def index
    @orders = current_user.orders
  end
  
  def show
    @order = current_user.orders.find_by_id(params[:id])
    unless @order || current_user.is_admin?
      flash[:alert] = "Could not find order"
      redirect_to root_path
    end
  end
  
  def lookup
    order = Order.find_by_special_url(params[:sid])
    if order && order.user == current_user
      redirect_to order_path(order)
    else
      flash[:alert] = "Could not find order"
      redirect_to root_path
    end
  end
end
