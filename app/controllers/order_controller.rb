class OrderController < ApplicationController
  def index
  end

  def show
  end

  def process_order
    flash[:notice] = "processed order"
    redirect_to checkout_path
  end
end
