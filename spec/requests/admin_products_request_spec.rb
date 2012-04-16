require 'spec_helper'

describe "Products" do
  context "for authenticated admin users" do
    let!(:admin_user) { Fabricate(:user_chad) }
    
    before(:each) do
      login_user_post(admin_user.email_address)
    end
    
    context "with existing products" do
      let!(:product_1)  { Fabricate(:product) }
      let!(:product_2)  { Fabricate(:product) }
      let!(:products)   { [product_1, product_2] }

      context "#index" do
        before(:each) { visit admin_products_path }
      
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
          within "#product_#{product_2.id}" do
            click_link "Edit"
          end
          current_path.should == edit_admin_product_path(product_2)
        end
        
        it "destroys a product after clicking delete" do
          within "#product_#{product_1.id}" do
            click_link "Destroy"
          end
          current_path.should == admin_products_path
          page.should have_content "The product has been deleted."
          page.should_not have_selector "#product_#{product_1.id}"
        end
        
        it "redirects to the product's new page after clicking new" do
          find("#create_product").click
          current_path.should == new_admin_product_path
        end
      end

      context "#edit" do
        let!(:product_category_1)  { Fabricate(:product_category) }
        let!(:product_category_2)  { Fabricate(:product_category) }
        
        before(:each) do
          product_1.product_categories << product_category_2
          visit edit_admin_product_path(product_1)
        end

        context "using valid attributes" do
          it "modifies the title on save" do
            title = Faker::Lorem.words(1).first
            fill_in "Title", :with => title
            click_link_or_button "Update Product"
            current_path.should == admin_product_path(product_1)
            page.should have_content "Product was successfully updated."
            within "#product_title" do
              page.should have_content title
            end
          end

          it "modifies the description on save" do
            description = Faker::Lorem.paragraphs(1).first
            fill_in "Description", :with => description
            click_link_or_button "Update Product"
            current_path.should == admin_product_path(product_1)
            page.should have_content "Product was successfully updated."
            within "#product_description" do
              page.should have_content description
            end
          end

          it "modifies the price on save" do
            price = "1.43"
            fill_in "Price", :with => price
            click_link_or_button "Update Product"
            current_path.should == admin_product_path(product_1)
            page.should have_content "Product was successfully updated."
            within "#product_price" do
              page.should have_content price
            end
          end

          it "modifies the photo url on save" do
            url = "http://a1.ak.lscdn.net/deals/images/refresh/branding/livingsocial-logo.png"
            fill_in "Photo url", :with => url
            click_link_or_button "Update Product"
            current_path.should == admin_product_path(product_1)
            page.should have_content "Product was successfully updated."
            within "#product_photo_url" do
              page.should have_content url
            end
          end

          it "modifies the active value on save" do
            uncheck "Active"
            click_link_or_button "Update Product"
            current_path.should == admin_product_path(product_1)
            page.should have_content "Product was successfully updated."
            page.should have_selector ".icon-remove"
          end
        end

        context "regarding categories" do
          it "adds a category to a product when a category is selected" do
            select(product_category_1.name, :from => "product_product_category_ids")
            click_link_or_button "Update Product"
            within "#product_categories" do
              page.should have_content product_category_1.name
              page.should have_content product_category_2.name
            end
          end
          
          it "removes a category to a product when a category is deselected" do
            unselect(product_category_2.name, :from => "product_product_category_ids")
            click_link_or_button "Update Product"
            within "#product_categories" do
              page.should_not have_content product_category_1.name
              page.should_not have_content product_category_2.name
            end
          end
        end
        
        context "using invalid attributes" do
          it "returns an error when attempting to save without a title" do
            fill_in "Title", :with => ""
            click_link_or_button "Update Product"
            current_path.should == admin_product_path(product_1)
            page.should have_content "Title can't be blank"
          end
          
          it "returns an error when attempting to save without a description" do
            fill_in "Description", :with => ""
            click_link_or_button "Update Product"
            current_path.should == admin_product_path(product_1)
            page.should have_content "Description can't be blank"
          end

          it "returns an error when attempting to save without a price" do
            fill_in "Price", :with => ""
            click_link_or_button "Update Product"
            current_path.should == admin_product_path(product_1)
            page.should have_content "Price can't be blank"
          end
        end
      end
    end
  end
end
