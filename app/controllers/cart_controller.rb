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
    unless params[:commit] == "Empty Cart"
      @cart.update_cart_quantities(params[:cp_id_quant])
      flash[:notice] = "Cart updated."
    else
      @cart.destroy
      flash[:notice] = "Your cart has been cleared."
    end
    redirect_to cart_show_path
  end

  def remove_product
    product_title = @cart.remove_product(params[:cp_id])
    flash[:notice] = "\'#{product_title}\' was removed from your cart."
    redirect_to cart_show_path
  end

  def checkout
    @user = current_user if current_user
    @credit_card = @user.credit_card if (@user && @user.has_existing_credit_card?)
    @billing_address = @user.billing_address if (@user && @user.has_existing_billing_address?)
    @shipping_address = @user.shipping_address if (@user && @user.has_existing_shipping_address?)
  end
end
