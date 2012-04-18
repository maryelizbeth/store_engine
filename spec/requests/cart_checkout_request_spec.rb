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
        context "after entering valid information" do
          before(:each) do
            visit checkout_path
          
            within "#payment_info_form" do
              fill_in "Card Number", :with => "1234567890123456"
              fill_in "Expiration Month", :with => "02"
              fill_in "Expiration Year", :with => "2018"
              fill_in "CCV", :with => "123"
            end
            within "#billing_address_form" do
              fill_in "Street Address 1", :with => "123 11th St."
              fill_in "Street Address 2", :with => "Apartment 201"
              fill_in "City", :with => "Washington"
              fill_in "State", :with => "DC"
              fill_in "Zip Code", :with => "20001"
            end
          end

          context "using a different shipping address than billing address" do
            before(:each) do
              within "#shipping_address_form" do
                fill_in "Street Address 1", :with => "321 12th St."
                fill_in "Street Address 2", :with => "Apt. 211"
                fill_in "City", :with => "Bethesda"
                fill_in "State", :with => "MD"
                fill_in "Zip Code", :with => "20814"
              end

              find("#checkout_button").click
              @order = Order.last
            end
        
            it "informs the user that the order was succefully created" do
              find("#notice").text.should have_content "Order successfully processed."
            end
        
            it "saved the correct credit card information for the user's order" do
              @order.user.credit_card.card_number.should == "1234567890123456"
              @order.user.credit_card.expiration_month.should == "02"
              @order.user.credit_card.expiration_year.should == "2018"
              @order.user.credit_card.ccv.should == "123"
            end

            it "saved the correct billing address information for the user's order" do
              @order.user.billing_address.street_1.should == "123 11th St."
              @order.user.billing_address.street_2.should == "Apartment 201"
              @order.user.billing_address.city.should == "Washington"
              @order.user.billing_address.state.should == "DC"
              @order.user.billing_address.zip_code.should == "20001"
            end

            it "saved the correct shipping address information for the user's order" do
              @order.user.shipping_address.street_1.should == "321 12th St."
              @order.user.shipping_address.street_2.should == "Apt. 211"
              @order.user.shipping_address.city.should == "Bethesda"
              @order.user.shipping_address.state.should == "MD"
              @order.user.shipping_address.zip_code.should == "20814"
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

          context "using the same address for billing and shipping" do
            before(:each) do
              check "shipping_address_use_billing"
              find("#checkout_button").click
              @order = Order.last
            end

            it "informs the user that the order was succefully created" do
              find("#notice").text.should have_content "Order successfully processed."
            end

            it "saved the correct credit card information for the user's order" do
              @order.user.credit_card.card_number.should == "1234567890123456"
              @order.user.credit_card.expiration_month.should == "02"
              @order.user.credit_card.expiration_year.should == "2018"
              @order.user.credit_card.ccv.should == "123"
            end

            it "saved the correct billing address information for the user's order" do
              @order.user.billing_address.street_1.should == "123 11th St."
              @order.user.billing_address.street_2.should == "Apartment 201"
              @order.user.billing_address.city.should == "Washington"
              @order.user.billing_address.state.should == "DC"
              @order.user.billing_address.zip_code.should == "20001"
            end

            it "saved the correct shipping address information for the user's order" do
              @order.user.shipping_address.street_1.should == "123 11th St."
              @order.user.shipping_address.street_2.should == "Apartment 201"
              @order.user.shipping_address.city.should == "Washington"
              @order.user.shipping_address.state.should == "DC"
              @order.user.shipping_address.zip_code.should == "20001"
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
        end
        
        context "after entering no information" do
          before(:each) do
            visit checkout_path
          end
          
          it "does not create a new order" do
            expect { find("#checkout_button").click }.to_not change{ Order.count }.by(1)
          end
          
          it "redirects the user back to the checkout page" do
            find("#checkout_button").click
            current_path.should == checkout_path
          end
          
          it "informs the user that the order was not processed" do
            find("#checkout_button").click
            find("#alert").text.should have_content "Order process failed."
          end
        end
      end
    end
    
    context "there are no items in the cart" do
      it "needs to handle this case"
    end
  end
  
  context "user is unauthenticated" do
    context "user has an existing account" do
      it "needs to handle this case"
    end
      
    context "user has no existing account" do
      it "needs to handle this case"
    end
  end
end