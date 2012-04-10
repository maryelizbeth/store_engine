require 'spec_helper'

describe "Products" do
  context "for authenticated admin users" do
    let!(:admin_user) { Fabricate(:user_chad) }
    
    before(:each) do
      login_user_post(admin_user.email_address)
    end
    
    context "with existing products" do
      let!(:products) { [Fabricate(:product), Fabricate(:product)]}

      context "#index" do
        before(:each) { visit products_path }
      
        it "displays the id of each existing product" do
          products.each do |product|
            within "#product_#{product.id}" do
              find(".id").text == product.id.to_s
            end
          end
        end
      
        it "displays the title of each existing product" do
          products.each do |product|
            within "#product_#{product.id}" do
              find(".title").text == product.title
            end
          end
        end
      
        it "displays the price of each existing product" do
          products.each do |product|
            within "#product_#{product.id}" do
              find(".price").text == "$#{product.price}"
            end
          end
        end
        
        it "redirects to the product's edit page after clicking edit" do
          product = products.first
          within "#product_#{product.id}" do
            click_link "Edit"
          end
          current_path.should == edit_product_path(product)
        end
        
        it "destroys a product after clicking delete" do
          product = products.last
          within "#product_#{product.id}" do
            click_link "Destroy"
          end
          current_path.should == products_path
          page.should have_content "The product has been deleted."
          page.should_not have_selector "#product_#{product.id}"
        end
      end
    end
  end
end
