class AddQuantityToCartProduct < ActiveRecord::Migration
  def change
    add_column :cart_products, :quantity, :integer
  end
end
