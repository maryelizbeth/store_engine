class StoreController < ApplicationController
  # skip_before_filter :require_login, :only => [:index]
  def index
    if params[:category_id] && !params[:category_id].empty?
      @products = ProductCategory.find(params[:category_id]).products
    else
      @products = Product.all
    end  
    @product_categories = ProductCategory.all
  end

  def add_to_cart
    if current_user
      if !current_user.has_a_shopping_cart?
        Order.create!(:user_id => current_user.id)
      end
      product = Product.find(params[:product_id])
      OrderProduct.create!(
        :order_id => current_user.shopping_cart.id,
        :product_id => product.id,
        :price => product.price,
        :quantity => params[:quantity])
    end
    redirect_to store_index_path
  end
end
