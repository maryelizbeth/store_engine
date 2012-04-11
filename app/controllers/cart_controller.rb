class CartController < ApplicationController
  before_filter :find_cart_from_session
  skip_before_filter :require_login, :except => :checkout

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
    @user = current_user
  end
  
  def convert_cart_to_order
    raise params.inspect
    @order = Order.new
    @order.status = :pending
    @order.special_url = create_special_url
    @order.user_id = current_user.id
    @cart.cart_products.each do |cp|
      op = @order.order_products.build
      op.update_attributes(:product_id => cp.product.id,
                          :quantity => cp.quantity,
                          :price => cp.price)
    end
    @order.save
    @cart.delete

    redirect_to order_path(@order)
  end
  
  private
  
  def create_special_url
    Digest::SHA1.hexdigest("#{Time.now.to_i.to_s + current_user.full_name}")
  end
end
