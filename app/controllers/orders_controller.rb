class OrdersController < ApplicationController
  
  def index
  end

  def show
    @order = Order.find(params[:id])
    unless @order.user == current_user || current_user.is_admin?
      flash[:alert] = "Could not find order"
      redirect_to root_path
    else
      @special_url = orders_lookup_url(:sid => @order.special_url)
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
