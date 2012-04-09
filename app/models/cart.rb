class Cart < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :cart_products
  has_many :products, :through => :cart_products

  def add_product(product, quantity)
    cp = CartProduct.find(:first, :conditions => ["product_id = ? and cart_id = ?", product.id, self.id])
    if cp
      cp.update_attribute(:quantity, cp.quantity + quantity.to_i)
    else
      CartProduct.create(:cart_id => self.id, :product_id => product.id, :quantity => quantity, :price => product.price)
    end 
  end
  
  def add_product_to_cart(product_id, quantity)
    product = Product.find_by_id(product_id)
    add_product(product, quantity)
  end

  def remove_product(cp_id)
    cart_product = CartProduct.find_by_id(cp_id)
    product_title = cart_product.product.title
    cart_product.delete
    product_title
  end

  def update_cart_quantities(line_items)
    self.cart_products.each do |cp|
      line_items.each do |li|
        if li.first == cp.id.to_s
          value = li.last.to_i
          if value > 0
            cp.update_attribute(:quantity, value)
          elsif value == 0
            cp.delete
          end
        end
      end
    end
  end
end
