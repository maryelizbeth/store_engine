class Admin::OrdersController < ApplicationController
  before_filter :require_admin
  
  def index
    @orders = Order.all
  end
  
  def show
    @order = Order.find(params[:id])
  end
end
