require 'spec_helper'

describe "User Types" do
  context "Administrator" do
    let!(:admin_user) { Fabricate(:admin_user) }
    
    before(:each) do
      login_user_post(admin_user.email_address)
    end
    
    it "can access the admin product screen" do
      within "ul.nav" do
        click_link "Admin Dashboards"
        click_link "Create, View, & Edit Products"
        current_path.should == admin_products_path
      end
    end
    
    it "can access the admin product categories screen" do
      within "ul.nav" do
        click_link "Admin Dashboards"
        click_link "Create, View, & Edit Product Categories"
        current_path.should == admin_product_categories_path
      end
    end
  end
  
  context "Authenticated User" do
    let!(:user)     { Fabricate(:user) }
    let!(:product)  { Fabricate(:product) }
    
    before(:each) do
      login_user_post(user.email_address)
    end
    
    context "for admin features in nav" do
      it "can not access the admin product screen" do
        within "ul.nav" do
          page.should_not have_selector "#product_menu"
          page.should_not have_selector "#products_editor"
        end
        visit admin_products_path
        current_path.should_not == admin_products_path
      end

      it "can not access the product edit screen" do
        within "ul.nav" do
          page.should_not have_selector "#product_menu"
          page.should_not have_selector "#categories_editor"
        end
        visit admin_product_categories_path
        current_path.should_not == admin_product_categories_path
      end
    end
    
    context "for user show pages" do
      context "when visiting your own user show page" do
        before(:each) do
          visit user_path(user)
        end
        
        it "should allow access" do
          current_path.should == user_path(user)
          page.should have_selector "#user_email_address"
        end
        
        it "displays the user's full name" do
          find("#user_full_name").text.should have_content user.full_name
        end
        
        it "displays the user's display name" do
          find("#user_display_name").text.should have_content user.display_name
        end
        
        it "displays the user's email address" do
          find("#user_email_address").text.should have_content user.email_address
        end
        
        it "contains a link to view past orders" do
          find("#user_past_orders_button").click
          current_path.should == orders_path
        end
        
        context "with an existing credit card" do
          let!(:credit_card_1)      { Fabricate(:credit_card, :user => user) }
          
          before(:each) do
            visit user_path(user)
          end
          
          it "displays the masked number" do
            find("#user_credit_card").text.should have_content credit_card_1.masked_number
          end
          
          it "should not display the actual card number" do
            find("#user_credit_card").text.should_not have_content credit_card_1.card_number
          end
        end
        
        context "without an existing credit card" do
          it "displays none" do
            find("#user_credit_card").text.should have_content "None"
          end
        end
        
        context "with an existing billing address" do
          let!(:billing_address_1)  { Fabricate(:billing_address, :user => user) }
          
          before(:each) do
            visit user_path(user)
          end
          
          it "displays the primary street address" do
            find("#user_billing_address").text.should have_content billing_address_1.street_1
          end

          it "displays the secondary street address" do
            find("#user_billing_address").text.should have_content billing_address_1.street_2
          end

          it "displays the city" do
            find("#user_billing_address").text.should have_content billing_address_1.city
          end

          it "displays the state" do
            find("#user_billing_address").text.should have_content billing_address_1.state
          end

          it "displays the zip code" do
            find("#user_billing_address").text.should have_content billing_address_1.zip_code
          end
        end
        
        context "without an existing billing address" do
          it "displays none" do
            find("#user_billing_address").text.should have_content "None"
          end
        end
        
        context "with an existing shipping address" do
          let!(:shipping_address_1) { Fabricate(:shipping_address, :user => user) }
          
          before(:each) do
            visit user_path(user)
          end

          it "displays the primary street address" do
            find("#user_shipping_address").text.should have_content shipping_address_1.street_1
          end

          it "displays the secondary street address" do
            find("#user_shipping_address").text.should have_content shipping_address_1.street_2
          end

          it "displays the city" do
            find("#user_shipping_address").text.should have_content shipping_address_1.city
          end

          it "displays the state" do
            find("#user_shipping_address").text.should have_content shipping_address_1.state
          end

          it "displays the zip code" do
            find("#user_shipping_address").text.should have_content shipping_address_1.zip_code
          end
        end
        
        context "without an existing shipping address" do
          it "displays none" do
            find("#user_shipping_address").text.should have_content "None"
          end
        end
      end
      
      context "when visiting someone else's user show page" do
        let!(:user_2)   { Fabricate(:user) }
        
        before(:each) do
          visit user_path(user_2)
        end
        
        it "should not allow access" do
          current_path.should_not == user_path(user)
          page.should_not have_selector "#user_email_address"
        end
      end
    end
  end
end