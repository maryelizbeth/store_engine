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
end
