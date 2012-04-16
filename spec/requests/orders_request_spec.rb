require 'spec_helper'

describe "Orders requests" do
  context "for users with orders" do
    let!(:user_1)     { Fabricate(:user) }
    let!(:user_2)     { Fabricate(:user) }
    let!(:product_1)  { Fabricate(:product) }
    let!(:product_2)  { Fabricate(:product) }
    let!(:order_1)    { Fabricate(:order, :user_id => user_1.id) }
    let!(:order_product_1)  { Fabricate(:order_product, :order => order_1, :product => product_1, :price => product_1.price) }
    let!(:order_2)    { Fabricate(:order, :user_id => user_2.id) }
    let!(:order_product_2)  { Fabricate(:order_product, :order => order_2, :product => product_2, :price => product_2.price) }
    let!(:order_3)    { Fabricate(:order, :user_id => user_1.id) }
    let!(:order_product_3)  { Fabricate(:order_product, :order => order_3, :product => product_2, :price => product_2.price) }

    context "when authenticated" do
      before(:each) do
        login_user_post(user_1.email_address)
      end
      
      context "on the orders index page" do
        before(:each) do
          visit orders_path
        end
        
        it "only displays orders placed by that user" do
          page.should have_selector "#order_#{order_1.id}"
          page.should have_selector "#order_#{order_3.id}"
          page.should_not have_selector "#order_#{order_2.id}"
        end
      end
      
      context "when trying to access an order page" do
        context "as the user who placed the order" do
          context "using the order id path" do
            before(:each) do
              visit order_path(order_1)
            end
            
            it "allows access to the order page" do
              current_path.should == order_path(order_1)
            end
          end
          
          context "using the order's special url" do
            before(:each) do
              visit orders_lookup_path(:sid => order_3.special_url)
            end

            it "allows access to the order page" do
              current_path.should == order_path(order_3)
            end
          end
        end
        
        context "as a different user" do
          context "using the order id path" do
            before(:each) do
              visit order_path(order_2)
            end
            
            it "redirects the user to the homepage" do
              current_path.should == root_path
            end
            
            it "informs the user that the order could not be found" do
              find("#alert").text.should have_content "Could not find order"
            end
          end
          
          context "using the order's special url" do
            before(:each) do
              visit orders_lookup_path(:sid => order_2.special_url)
            end

            it "redirects the user to the homepage" do
              current_path.should == root_path
            end
            
            it "informs the user that the order could not be found" do
              find("#alert").text.should have_content "Could not find order"
            end
          end
        end
      end
    end
  end
end