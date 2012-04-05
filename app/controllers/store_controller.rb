class StoreController < ApplicationController
  skip_before_filter :require_login
  before_filter :find_cart_from_session

  def index
    if params[:category_id] && !params[:category_id].empty?
      @products = ProductCategory.find(params[:category_id]).products
    else
      @products = Product.all
    end  
    @product_categories = ProductCategory.all
  end

  def add_to_cart
    @cart.add_product_to_cart(params[:product_id])
    session[:cart_id] = @cart.id
    redirect_to store_index_path
  end

  private

  def find_cart_from_session
    @cart = Cart.find_by_id(session[:cart_id]) if session[:cart_id]
    @cart ||= Cart.create
  end
end
