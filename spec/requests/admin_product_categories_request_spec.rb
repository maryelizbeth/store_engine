require 'spec_helper'

describe "ProductCategories" do
  context "when logged in as an admin" do
    let!(:admin_user)   { Fabricate(:admin_user) }
    before(:each) do
      login_user_post(admin_user.email_address)
    end

    context "#index" do      
      context "with existing product categories" do
        let!(:product_category_1)   { Fabricate(:product_category) }
        let!(:product_category_2)   { Fabricate(:product_category) }
        let!(:product_categories)   { [product_category_1, product_category_2] }
        let!(:product_1)            { Fabricate(:product, :product_categories => [product_category_1]) }
        let!(:product_2)            { Fabricate(:product) }
        let!(:product_3)            { Fabricate(:product) }
        let!(:product_4)            { Fabricate(:product) }
        let!(:products)             { [product_1, product_2, product_3, product_4] }
      
        before(:each) do
          visit admin_product_categories_path
        end

        it "displays each product category's id" do
          product_categories.each do |pc|
            within "#product_category_#{pc.id}_id" do
              page.should have_content pc.id
            end
          end
        end
      
        it "displays each product category's name" do
          product_categories.each do |pc|
            within "#product_category_#{pc.id}_name" do
              page.should have_content pc.name
            end
          end
        end
        
        it "displays each product category's product count" do
          product_categories.each do |pc|
            within "#product_category_#{pc.id}_count" do
              page.should have_content pc.product_count
            end
          end
        end
        
        context "when editing a product category" do
          before(:each) do
            find("#product_category_#{product_category_1.id}_edit").click
          end
          
          context "after updating a product category's name" do
            context "using valid data" do
              before(:each) do
                fill_in "Name", :with => "New Name"
                click_button "Update Product category"
              end
            
              it "updates the product category's name" do
                within "#product_category_name" do
                  page.should have_content "New Name"
                end
              end
            end

            context "using invalid data" do
              before(:each) do
                fill_in "Name", :with => ""
                click_button "Update Product category"
              end
              
              it "redirects back to the product category page" do
                current_path.should == admin_product_category_path(product_category_1)
              end
              
              it "returns an error" do
                find("#error_explanation").text.should have_content "Name can't be blank"
              end
            end
          end
          
          context "after updating a product category's product assignment" do
            before(:each) do
              products.each do |product|
                select(product.title, :from => "product_category_product_ids")
              end
              click_button "Update Product category"
            end
            
            it "updates the product category's name" do
              products.each do |product|
                find("#product_#{product.id}").text.should have_content product.title
              end
            end
          end
        end
        
        context "when destroying a product category" do
          it "deletes the product category when clicking delete" do
            within "#product_category_#{product_category_1.id}" do
              click_link "Destroy"
            end
            page.should_not have_selector "#product_category_#{product_category_1.id}"
          end
        end
        
        context "when creating a new product category" do
          context "using valid data" do
            before(:each) do
              find("#create_product_category").click
              fill_in "Name", :with => "Very Unique Name"
              click_button "Create Product category"
              @new_product_category = ProductCategory.last
            end
          
            it "redirects to the newly created product category's page" do
              current_path.should == admin_product_category_path(@new_product_category)
            end
          
            it "displays the product category's name" do
              find("#product_category_name").text.should have_content "Very Unique Name"
            end
          end
          
          context "using invalid data" do
            before(:each) do
              find("#create_product_category").click
              fill_in "Name", :with => ""
              click_button "Create Product category"
              @new_product_category = ProductCategory.last
            end
          
            it "redirects to the newly created product category's page" do
              current_path.should == admin_product_categories_path
            end
          
            it "displays the product category's name" do
              find("#error_explanation").text.should have_content "Name can't be blank"
            end
          end
        end
      end
    end
  end
end
