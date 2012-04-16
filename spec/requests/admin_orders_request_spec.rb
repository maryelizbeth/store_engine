require 'spec_helper'

describe "Admin Order requests" do
  context "when authenticated as an admin user" do
    let!(:admin_user)   { Fabricate(:admin_user) }
    
    before(:each) do
      login_user_post(admin_user.email_address)
    end
    
    context "with existing orders" do
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
      let!(:orders)     { [order_1, order_2, order_3] }
      
      context "visiting the admin orders index page" do
        before(:each) do
          visit admin_orders_path
        end
        
        it "displays all orders" do
          orders.each do |order|
            page.should have_selector "#order_#{order.id}"
          end
        end
        
        it "displays the id of an order" do
          find("#order_#{order_2.id}_id").should have_content order_2.id
        end
        
        it "displays the user's full name for an order" do
          find("#order_#{order_2.id}_user_full_name").should have_content user_2.full_name
        end
        
        it "displays the status of an order" do
          find("#order_#{order_2.id}_status").should have_content "pending"
        end
        
        context "when filtering by status" do
          before(:each) do
            order_2.transition("process-payment")
            select("pending", :from => "order_status")
            find("#submit_status_filter").click
          end
          
          it "only displays the orders with the filtered status" do
            page.should have_selector "#order_#{order_1.id}"
            page.should have_selector "#order_#{order_3.id}"
            page.should_not have_selector "#order_#{order_2.id}"
          end
        end
        
        context "when clicking 'View' for an order" do
          before(:each) do
            find("#order_#{order_2.id}_view").click
          end
          
          it "takes you to the admin page for that order" do
            current_path.should == admin_order_path(order_2)
          end
        end
        
        context "regarding transitions" do
          context "for pending orders" do
            it "transitions to paid after processing payment" do
              within "#order_#{order_3.id}_transitions" do
                click_link "Process payment"
              end
              find("#notice").text.should have_content "Order successfully transtitioned from 'pending' to 'paid'"
              find("#order_#{order_3.id}_status").should have_content "paid"
            end
            
            it "transitions to canceled after cancelling the order" do
              within "#order_#{order_1.id}_transitions" do
                click_link "Cancel"
              end
              find("#notice").text.should have_content "Order successfully transtitioned from 'pending' to 'canceled'"
              find("#order_#{order_1.id}_status").should have_content "canceled"
            end
          end
          
          context "for paid orders" do
            before(:each) do
              order_3.transition("process-payment")
              visit admin_orders_path
            end
            
            it "transitions to shipped after shipping the order" do
              within "#order_#{order_3.id}_transitions" do
                click_link "Ship"
              end
              find("#notice").text.should have_content "Order successfully transtitioned from 'paid' to 'shipped'"
              find("#order_#{order_3.id}_status").should have_content "shipped"
            end
          end
          
          context "for shipped orders" do
            before(:each) do
              order_3.transition("process-payment")
              order_3.transition("ship")
              visit admin_orders_path
            end
            
            it "transitions to shipped after shipping the order" do
              within "#order_#{order_3.id}_transitions" do
                click_link "Return"
              end
              find("#notice").text.should have_content "Order successfully transtitioned from 'shipped' to 'returned'"
              find("#order_#{order_3.id}_status").should have_content "returned"
            end
          end
        end
      end
    end
  end

  context "when not authenticated as an admin user" do
    let!(:user_3)     { Fabricate(:user) }
    
    before(:each) do
      login_user_post(user_3.email_address)
    end
    
    context "with existing orders" do
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
      let!(:orders)     { [order_1, order_2, order_3] }
      
      context "visiting the admin orders index page" do
        before(:each) do
          visit admin_orders_path
        end
        
        it "redirects me to the homepage" do
          current_path.should == root_path
        end
      end
      
      context "visiting the admin page for an order" do
        before(:each) do
          visit admin_order_path(order_1)
        end
        
        it "redirects me to the homepage" do
          current_path.should == root_path
        end
      end
    end
  end
end