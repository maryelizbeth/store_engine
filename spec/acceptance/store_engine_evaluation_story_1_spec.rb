require 'spec_helper'

# Anonymous Shopper Makes a Purchase

feature "Checking Out While Logged Out", :js => true, :acceptance => true do
  let!(:product_1)  { Fabricate(:product) }
  let!(:product_2)  { Fabricate(:product) }
  let!(:products)   { [product_1, product_2] }

  before(:each) do
    visit logout_path
  end
  
  context "Viewing products on the home page" do
    before(:each) do
      visit root_path
    end
    
    it "displays all products" do
      products.each do |product|
        page.should have_selector "#store_product_#{product.id}_image"
        find("#store_product_#{product.id}_title").text.should have_content product.title
        find("#store_product_#{product.id}_price").text.should have_content number_to_currency(product.price)
      end
    end
  end
  
  context "Viewing details for a product" do
    before(:each) do
      visit root_path
      click_link product_1.title
    end
    
    it "displays the product's details" do
      find("#index-prod-title").text.should have_content product_1.title
      find("#prod_descrip").text.should have_content product_1.description
      find("#index-prod-title").text.should have_content number_to_currency(product_1.price)
      find("#product_image")[:src].should have_content "/assets/no_image.jpg"
    end
    
    it "displays an add to cart button" do
      page.should have_selector "#add_to_cart_button"
    end
  end
  
  context "Adding to cart" do
    before(:each) do
      visit product_path(product_1)
      find("#add_to_cart_button").click
    end
    
    it "displays my cart containing 1 of the product" do
      current_path.should == cart_show_path
      find("#cart_item_#{product_1.id}_title").should have_content product_1.title
      within "#cart_item_#{product_1.id}" do
        find(".quantity").value.should == "1"
      end
      find("#cart_item_#{product_1.id}_price").should have_content number_to_currency(product_1.price)
      find("#cart_item_#{product_1.id}_total").should have_content number_to_currency(product_1.price)
    end
    
    it "displays the correct cart total" do
      find("#total-amount").should have_content number_to_currency(product_1.price)
    end
  end
  
  context "Checking out" do
    before(:each) do
      visit product_path(product_1)
      find("#add_to_cart_button").click
      visit cart_show_path
      find("#checkout_button").click
    end
    
    it "requires that I login to procced" do
      current_path.should == login_path
    end
    
    context "after logging in" do
      let!(:matt_yoho)    { Fabricate(:user_matt) }
      
      before(:each) do
        fill_in "Email", :with => matt_yoho.email_address
        fill_in "Password", :with => "hungry"
        click_button "Login"
      end
      
      it "asks for billing and shipping information" do
        page.should have_selector "#payment_info_form"
        page.should have_selector "#billing_address_form"
        page.should have_selector "#shipping_address_form"
      end
      
      context "Checking Out After Logging In" do
        before(:each) do
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
          check "shipping_address_use_billing"
          
          find("#checkout_button").click
          @order = Order.last
        end
        
        it "should display an order summary page with the correct status and order total" do
          current_path.should == order_path(@order)
          find("#order_status").text.should have_content "paid"
          find("#order_total").text.should have_content number_to_currency(product_1.price)
        end
      end
    end
  end
end