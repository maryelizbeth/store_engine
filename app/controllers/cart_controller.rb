class CartController < ApplicationController
  skip_before_filter :require_login, :except => :checkout

  def show
  end

  def two_click_checkout
    @cart.add_product_to_cart(params[:product_id])
    process_order
    redirect_to order_path(@order)
  end
  
  def add_to_cart
    @product_title = @cart.add_product_to_cart(params[:product_id])
    session[:cart_id] = @cart.id
    respond_to do |format|
      format.html   { redirect_to cart_show_path, notice: "\'#{@product_title}\' was added to your cart." }
      format.js
    end
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
    unless current_user.has_existing_credit_card?
      card_ok = build_credit_card(params[:billing_type])
    else
      card_ok = true
    end
    unless current_user.has_existing_billing_address?
      billing_address_ok = build_address(params[:billing_address], "billing")
    else
      billing_address_ok = true
    end
    unless current_user.has_existing_shipping_address?
      shipping_address_ok = build_address(params[:shipping_address], "shipping")
    else 
      shipping_address_ok = true
    end
    if card_ok && billing_address_ok && shipping_address_ok
      process_order
      redirect_to order_path(@order)
    else
      flash[:alert] = "Order process failed."
      redirect_to checkout_path
    end
  end
  
  private
  
  def create_special_url
    Digest::SHA1.hexdigest("#{Time.now.to_i.to_s + current_user.full_name}")
  end
  
  def process_order
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
  end
  
  def build_credit_card(billing_info)
    cc = current_user.credit_cards.build
    cc.update_attributes(:card_number => billing_info[:card_number],
                        :expiration_month => billing_info[:expiration_month],
                        :expiration_year => billing_info[:expiration_year],
                        :ccv => billing_info[:ccv])
    cc.save
  end
  
  def build_address(address, address_type)
    ba = current_user.addresses.build
    ba.update_attributes(:address_type => address_type,
                        :street_1 => address[:street_address1],
                        :street_2 => address[:street_address2],
                        :city => address[:city],
                        :state => address[:state],
                        :zip_code => address[:zipcode])
    ba.save
  end
end
