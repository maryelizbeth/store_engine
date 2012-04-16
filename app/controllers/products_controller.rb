class ProductsController < ApplicationController
  skip_before_filter :require_login

  def index
    if params[:category_id] && !params[:category_id].empty?
      @selected_category_id = params[:category_id].to_i
      @products = ProductCategory.find_by_id(@selected_category_id).active_products
    else
      @products = all_active_products
    end  
    @product_categories = ProductCategory.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end
  
  private
  
  def all_active_products
    Product.find(:all, :conditions => ["active = ?", true])
  end
end
