require 'spec_helper'

describe "Cart checkout" do
  context "user is authenticated" do
    let!(:user_1)     { Fabricate(:user) }
    
    before(:each) do
      login_user_post(user_1.email_address)
    end
    
    context "there are items in the cart" do
      let!(:product_1)  { Fabricate(:product, :price => 3.51) }
      let!(:product_2)  { Fabricate(:product, :price => 101.01) }
      
      before(:each) do
        visit root_path     # visit a page to create a cart
        cart = Cart.last    # the last cart should be the cart on root path visit
        cart.add_product(product_1, 2)
        cart.add_product(product_2, 1)
      end
      
      context "the user has an existing credit card, billing address, & shipping address" do
        let!(:shipping_address_1) { Fabricate(:shipping_address, :user => user_1) }
        let!(:billing_address_1)  { Fabricate(:billing_address, :user => user_1) }
        let!(:credit_card_1)      { Fabricate(:credit_card, :user => user_1) }
        
        before(:each) do
          visit checkout_path
          find("#checkout_button").click
          @order = Order.last
        end
        
        it "informs the user that the order was succefully created" do
          find("#notice").text.should have_content "Order successfully processed."
        end
        
        context "on the order page" do
          it "displays the order's special url" do
            find("#order_special_url").should have_content orders_lookup_url(:sid => @order.special_url)
          end
          
          it "displays the correct order status" do
            find("#order_status").should have_content @order.status
          end
          
          it "displays the correct information for each item in the order" do
            op1 = @order.order_products.find_by_product_id(product_1.id)
            find("#order_item_#{op1.id}_title").text.should have_content product_1.title
            find("#order_item_#{op1.id}_price").text.should have_content number_to_currency(product_1.price)
            find("#order_item_#{op1.id}_quantity").text.should have_content "2"
            find("#order_item_#{op1.id}_total").text.should have_content number_to_currency(product_1.price * 2)
            op2 = @order.order_products.find_by_product_id(product_2.id)
            find("#order_item_#{op2.id}_title").text.should have_content product_2.title
            find("#order_item_#{op2.id}_price").text.should have_content number_to_currency(product_2.price)
            find("#order_item_#{op2.id}_quantity").text.should have_content "1"
            find("#order_item_#{op2.id}_total").text.should have_content number_to_currency(product_2.price)
          end
        end
      end
    
      context "the user has no existing credit card, no billing address, and no shipping address" do
        before(:each) do
          within ".payment-info" do
          end
          within ".billing-address" do
          end
          within ".shipping-address" do
          end
          visit checkout_path
          find("#checkout_button").click
          @order = Order.last
        end
      end
    end
    
    context "there are no items in the cart" do
    end
  end
  
  context "user is unauthenticated" do
    context "user has an existing account" do
    end
      
    context "user has no existing account" do
    end
  end
end