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
    @cart.add_product_to_cart(params[:product_id], params[:quantity])
    session[:cart_id] = @cart.id
    redirect_to cart_show_path
  end
end
