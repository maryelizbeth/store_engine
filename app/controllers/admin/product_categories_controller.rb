class Admin::ProductCategoriesController < ApplicationController
  before_filter :require_admin

  def index
    @product_categories = ProductCategory.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @product_category = ProductCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @product_category = ProductCategory.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @product_category = ProductCategory.find(params[:id])
  end

  def create
    @product_category = ProductCategory.new(params[:product_category])

    respond_to do |format|
      if @product_category.save
        format.html {
          redirect_to admin_product_category_path(@product_category),
          notice: 'Product category was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @product_category = ProductCategory.find(params[:id])

    respond_to do |format|
      if @product_category.update_attributes(params[:product_category])
        format.html {
          redirect_to admin_product_category_path(@product_category),
          notice: 'Product category was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @product_category = ProductCategory.find(params[:id])
    @product_category.destroy

    respond_to do |format|
      format.html { redirect_to admin_product_categories_url }
    end
  end
end