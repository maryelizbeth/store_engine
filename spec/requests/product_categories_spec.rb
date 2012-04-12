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
      
        before(:each) do
          visit product_categories_path
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
        
        it "redirects to the product category's edit page when clicking edit" do
          find("#product_category_#{product_category_1.id}_edit").click
          current_path.should == edit_product_category_path(product_category_1)
        end
        
        it "deletes the product category when clicking delete" do
          within "#product_category_#{product_category_1.id}" do
            click_link "Destroy"
          end
          page.should_not have_selector "#product_category_#{product_category_1.id}"
        end
      end
    end
  end
end
