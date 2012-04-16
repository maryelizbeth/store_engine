require 'spec_helper'

describe "Two click checkout" do
  context "on the product page" do
    let!(:product_1)      { Fabricate(:product) }
    
    context "for authenticated users" do
      let!(:user_1)       { Fabricate(:user) }
      
      before(:each) do
        login_user_post(user_1.email_address)
      end
      
      context "with a valid credit card, valid billing address, and valid shipping address" do
        let!(:shipping_address_1) { Fabricate(:shipping_address, :user => user_1) }
        let!(:billing_address_1)  { Fabricate(:billing_address, :user => user_1) }
        let!(:credit_card_1)      { Fabricate(:credit_card, :user => user_1) }
        
        context "for active products" do
          before(:each) do
            product_1.update_attribute(:active, true)
            visit product_path(product_1)
          end
          
          it "exposes the two click checkout feature" do
            page.should have_selector "#two_click_checkout"
          end
          
          context "after clicking the two click checkout element" do
            before(:each) do
              find("#two_click_checkout").click
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
                find("#order_item_#{op1.id}_quantity").text.should have_content "1"
                find("#order_item_#{op1.id}_total").text.should have_content number_to_currency(product_1.price)
              end
            end
          end
        end
        
        context "for inactive products" do
          before(:each) do
            product_1.update_attribute(:active, false)
            visit product_path(product_1)
          end
        
          it "hides the two click checkout feature" do
            page.should_not have_selector "#two_click_checkout"
          end
        end
      end
    end
    
    context "without a valid credit card, valid billing address, or valid shipping address" do
      context "for active products" do
        before(:each) do
          product_1.update_attribute(:active, true)
          visit product_path(product_1)
        end
        
        it "hides the two click checkout feature" do
          page.should_not have_selector "#two_click_checkout"
        end
      end
    end
  
    context "for unauthenticated users" do
      context "for active products" do
        before(:each) do
          product_1.update_attribute(:active, true)
          visit product_path(product_1)
        end
      
        it "hides the two click checkout feature" do
          page.should_not have_selector "#two_click_checkout"
        end
      end
    end
  end
end