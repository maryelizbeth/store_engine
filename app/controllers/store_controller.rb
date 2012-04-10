class StoreController < ApplicationController
  skip_before_filter :require_login
  before_filter :find_cart_from_session

  def index
    if params[:category_id] && !params[:category_id].empty?
      @products = ProductCategory.find(params[:category_id]).active_products
      @selected_category_id = params[:category_id]
    else
      @products = all_active_products
    end  
    @product_categories = ProductCategory.all
  end
  
  private
  
  def all_active_products
    Product.find(:all, :conditions => ["active = ?", true])
  end
end
