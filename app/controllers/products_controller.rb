class ProductsController < ApplicationController
  skip_before_filter :require_login

  def index
    if params[:category_id] && !params[:category_id].empty?
      @products = ProductCategory.find(params[:category_id]).active_products
      @selected_category_id = params[:category_id]
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
