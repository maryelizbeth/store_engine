require 'spec_helper'

# Adding Products To The Cart From Multiple Sources

feature "Adding Products To The Cart From Multiple Sources", :js => true, :acceptance => true do
  let!(:matt_yoho)    { Fabricate(:user_matt) }

  let!(:product_1)  { Fabricate(:product, :price => 1.11) }
  let!(:product_2)  { Fabricate(:product, :price => 2.22) }
  let!(:product_3)  { Fabricate(:product, :price => 3.33) }
  let!(:product_4)  { Fabricate(:product, :price => 4.44) }
  let!(:products)   { [product_1, product_2, product_3, product_4]}
  let!(:pc_1)       { Fabricate(:product_category) }
  let!(:pc_2)       { Fabricate(:product_category) }
  let!(:order_1)    { Fabricate(:order, :user_id => matt_yoho.id, :status => "paid") }
  let!(:order_product_1)  { Fabricate(:order_product, :order => order_1, :product => product_1, :price => product_1.price)}
  
  before(:each) do
    product_1.product_categories << pc_2
    product_2.product_categories << pc_2
    product_3.product_categories << pc_1
    product_4.product_categories << pc_2
    login_user(matt_yoho.email_address)
  end
  
  context "Viewing products by category" do
    before(:each) do
      select pc_2.name, :from => "category_id"
      @expected_products = [product_1, product_2, product_4]
      @unexpected_products = [product_3]
    end
    
    it "displays only the products for the selected category" do
      @expected_products.each do |product|
        page.should have_selector "#store_product_#{product.id}_image"
        within "#store_product_#{product.id}_title" do
          page.should have_content product.title
        end
        within "#store_product_#{product.id}_price" do
          page.should have_content product.price
        end
      end
    
      @unexpected_products.each do |product|
        page.should_not have_selector "#store_product_#{product.id}_image"
        page.should_not have_selector "#store_product_#{product.id}_title"
        page.should_not have_selector "#store_product_#{product.id}_price"
      end
    end
    
    context "Viewing details for a product" do
      before(:each) do
        click_link product_2.title
      end
      
      it "displays the product's details" do
        find("#index-prod-title").text.should have_content product_2.title
        find("#prod_descrip").text.should have_content product_2.description
        find("#index-prod-title").text.should have_content number_to_currency(product_2.price)
        find("#product_image")[:src].should have_content "/assets/no_image.jpg"
      end

      it "displays an add to cart button" do
        page.should have_selector "#add_to_cart_button"
      end
      
      context "Adding to cart" do
        before(:each) do
          find("#add_to_cart_button").click
        end

        it "displays my cart containing 1 of the product" do
          current_path.should == cart_show_path
          find("#cart_item_#{product_2.id}_title").should have_content product_2.title
          within "#cart_item_#{product_2.id}" do
            find(".quantity").value.should == "1"
          end
          find("#cart_item_#{product_2.id}_price").should have_content number_to_currency(product_2.price)
          find("#cart_item_#{product_2.id}_total").should have_content number_to_currency(product_2.price)
        end
        
        context "Viewing previous orders" do
          before(:each) do
            find("#view_past_orders").click
            within "#orders" do
              click_link "View"
            end
            click_link product_1.title
            find("#add_to_cart_button").click
          end
          
          it "displays my cart containing 1 of product 1 & product 2" do
            current_path.should == cart_show_path
            
            find("#cart_item_#{product_1.id}_title").should have_content product_1.title
            within "#cart_item_#{product_1.id}" do
              find(".quantity").value.should == "1"
            end
            find("#cart_item_#{product_1.id}_price").should have_content number_to_currency(product_1.price)
            find("#cart_item_#{product_1.id}_total").should have_content number_to_currency(product_1.price)

            find("#cart_item_#{product_2.id}_title").should have_content product_2.title
            within "#cart_item_#{product_2.id}" do
              find(".quantity").value.should == "1"
            end
            find("#cart_item_#{product_2.id}_price").should have_content number_to_currency(product_2.price)
            find("#cart_item_#{product_2.id}_total").should have_content number_to_currency(product_2.price)
          end
        end
      end
    end
  end
end