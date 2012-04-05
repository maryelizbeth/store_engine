class AddPriceToCartProducts < ActiveRecord::Migration
  def change
    add_column :cart_products, :price, :decimal
  end
end
