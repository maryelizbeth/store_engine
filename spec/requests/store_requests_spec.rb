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
        
    context "for active products" do
      before(:each) do
        product_2.product_categories << pc_2
        product_3.product_categories << pc_1
        product_4.product_categories << pc_2

        visit store_index_path
      end
    
      it "displays all products by default" do
        products.each do |product|
          page.should have_selector "#store_product_#{product.id}_image"
          find("#store_product_#{product.id}_title").text.should == product.title
          find("#store_product_#{product.id}_price").text.should == "$#{product.price}"
        end
      end
    
      it "only displays the products in the filtered category" do
        select pc_2.name, :from => "category_id"
        find("#submit_category_filter").click
        expected_products = [product_2, product_4]
        expected_products.each do |product|
          page.should have_selector "#store_product_#{product.id}_image"
          find("#store_product_#{product.id}_title").text.should == product.title
          find("#store_product_#{product.id}_price").text.should == "$#{product.price}"
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
        product_3.update_attribute(:active, false)
      end
      
      it "does not display inactive products" do
        visit store_index_path
        page.should_not have_selector "#store_product_#{product_3.id}_image"
        page.should_not have_selector "#store_product_#{product_3.id}_title"
        page.should_not have_selector "#store_product_#{product_3.id}_price"
      end
    end
  end
end
