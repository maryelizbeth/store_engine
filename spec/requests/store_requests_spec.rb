require 'spec_helper'

describe "Store Requests" do
  context "there are products and product cateogries" do
    let!(:product_1)  { Fabricate(:product, :price => 1.11) }
    let!(:product_2)  { Fabricate(:product, :price => 2.22) }
    let!(:product_3)  { Fabricate(:product, :price => 3.33) }
    let!(:product_4)  { Fabricate(:product, :price => 4.44) }
    let!(:products)   { [product_1, product_2, product_3, product_4]}
    let!(:pc_1)       { Fabricate(:product_category) }
    let!(:pc_2)       { Fabricate(:product_category) }
    
    before(:each) do
      product_2.product_categories << pc_2
      product_3.product_categories << pc_1
      product_4.product_categories << pc_2
    end
    
    context "for active products" do
      before(:each) do
        visit root_path
      end
    
      it "displays all products by default" do
        products.each do |product|
          page.should have_selector "#store_product_#{product.id}_image"
          within "#store_product_#{product.id}_title" do
            page.should have_content product.title
          end
          within "#store_product_#{product.id}_price" do
            page.should have_content product.price
          end
        end
      end
    
      it "only displays the products in the filtered category" do
        select pc_2.name, :from => "category_id"
        find("#submit_category_filter").click
        expected_products = [product_2, product_4]
        expected_products.each do |product|
          page.should have_selector "#store_product_#{product.id}_image"
          within "#store_product_#{product.id}_title" do
            page.should have_content product.title
          end
          within "#store_product_#{product.id}_price" do
            page.should have_content product.price
          end
        end
        unexpected_products = [product_1, product_3]
        unexpected_products.each do |product|
          page.should_not have_selector "#store_product_#{product.id}_image"
          page.should_not have_selector "#store_product_#{product.id}_title"
          page.should_not have_selector "#store_product_#{product.id}_price"
        end
      end
    end
    
    context "for inactive products" do
      before(:each) do
        product_2.update_attribute(:active, false)
        visit root_path
      end
      
      it "does not display inactive products when not filtering by category" do
        page.should_not have_selector "#store_product_#{product_2.id}_image"
        page.should_not have_selector "#store_product_#{product_2.id}_title"
        page.should_not have_selector "#store_product_#{product_2.id}_price"
      end
      
      it "does not display inactive products when filtering by category" do
        select pc_2.name, :from => "category_id"
        find("#submit_category_filter").click
        page.should have_selector "#store_product_#{product_4.id}_image"
        within "#store_product_#{product_4.id}_title" do
          page.should have_content product_4.title
        end
        within "#store_product_#{product_4.id}_price" do
          page.should have_content product_4.price
        end
        page.should_not have_selector "#store_product_#{product_2.id}_image"
        page.should_not have_selector "#store_product_#{product_2.id}_title"
        page.should_not have_selector "#store_product_#{product_2.id}_price"
      end
    end
  end
end
