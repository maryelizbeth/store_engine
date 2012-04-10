require 'spec_helper'

describe Cart do
  context "#total" do
    let!(:product_1)  { Fabricate(:product, :price => 1.11) }
    let!(:product_2)  { Fabricate(:product, :price => 2.22) }
    let!(:cart)       { Fabricate(:cart) }
    let!(:cart_product_1) { Fabricate(:cart_product, :cart_id => cart.id,
      :product_id => product_1.id, :price => product_1.price, :quantity => 3)}
    let!(:cart_product_2) { Fabricate(:cart_product, :cart_id => cart.id,
      :product_id => product_2.id, :price => product_2.price, :quantity => 2)}
      
    it "reports the total of all cart line items" do
      cart.total.should == 7.77
    end
  end
end
