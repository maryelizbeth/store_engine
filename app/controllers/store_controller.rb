class StoreController < ApplicationController
  skip_before_filter :require_login, :only => [:index]
  def index
    # raise params.class.inspect
    if params[:category_id] && !params[:category_id].empty?
      @products = ProductCategory.find(params[:category_id]).products
    else
      @products = Product.all
    end  
    @product_categories = ProductCategory.all

  end
end
