class CartController < ApplicationController
  before_filter :find_cart_from_session
  skip_before_filter :require_login

  def show
  end
  
  def add_to_cart
    @cart.add_product_to_cart(params[:product_id], params[:quantity])
    session[:cart_id] = @cart.id
    redirect_to cart_show_path
  end

  def update
    @cart.update_cart_quantities(params[:cp_id_quant])
    flash[:notice] = "Cart updated."
    redirect_to cart_show_path
  end

  def remove_product
    product_title = @cart.remove_product(params[:cp_id])
    flash[:notice] = "\'#{product_title}\' was removed from your cart."
    redirect_to cart_show_path
  end

  def checkout
    # flash[:notice] = "Checking out."
    # redirect_to cart_show_path    
  end
end
