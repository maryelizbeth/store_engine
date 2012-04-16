require 'spec_helper'

describe OrderProduct do
  context "#total" do
    let!(:order_product_1)    { Fabricate(:order_product, :quantity => 3, :price => 4.5) }
    
    it "returns the total amount" do
      order_product_1.total.should == 13.5
    end
  end
end
