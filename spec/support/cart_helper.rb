module StoreEngine
  module CartTestHelper
    def create_cart(products)
      cart = Cart.create
      products.each { |product| cart.add_product_to_cart(product, 1) }
      cart
    end
  end
end