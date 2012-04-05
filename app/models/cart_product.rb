class CartProduct < ActiveRecord::Base
  attr_accessible :cart_id, :product_id, :quantity, :price

  belongs_to :cart
  belongs_to :product

  def total
    quantity * price
  end
end
