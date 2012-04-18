require 'spec_helper'

describe "Product requests" do
  context "when displaying a specific product page" do
    let!(:product_1)    { Fabricate(:product) }
    
    before(:each) do
      visit product_path(product_1)
    end
    
    it "shows the product title" do
      find("#product_title").text.should have_content product_1.title
    end
    
    it "shows the product description" do
      find("#product_description").text.should have_content product_1.description
    end
    
    it "shows the product price" do
      find("#product_price").text.should have_content number_to_currency(product_1.price)
    end
    
    context "for a product's image" do
      context "when the product does not have a photo url value" do
        it "shows the correct product image" do
          find("#product_image")[:src].should == "/assets/no_image.jpg"
        end
      end
      
      context "when the product has a photo url value" do
        let!(:product_1)    { Fabricate(:product) }
        let!(:image_url)    { "http://www.google.com/images/srpr/logo3w.png" }
        
        before(:each) do
          product_1.update_attributes(:photo_url => image_url)
          visit product_path(product_1)
        end
        
        it "shows the correct product image" do
          find("#product_image")[:src].should == image_url
        end
      end
    end
  end
end