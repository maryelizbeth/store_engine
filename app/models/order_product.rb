class OrderProduct < ActiveRecord::Base
  attr_accessible :order_id, :price, :product_id, :quantity
  belongs_to :order 
  belongs_to :product
  
  def total
    quantity * price
  end
end
