require 'spec_helper'

describe Product do
  context "for attribute validations" do
    let (:new_product) { Product.new(:title => "Product Title",
                          :description => "Product Description",
                          :price => 1.75) }
    context "for title" do
      it "must have a title" do
        new_product.title = nil
        new_product.save.should be_false
        new_product.title = "Product Title"
        new_product.save.should be_true
      end

      it "must not be an empty string" do
        new_product.title = " "
        new_product.save.should be_false
        new_product.title = "Product Title"
        new_product.save.should be_true        
      end

      it "must be a unique title" do 
        product_1 = Fabricate(:product)
        new_product.title = product_1.title
        new_product.save.should be_false
        new_product.title = "Product Title"
        new_product.save.should be_true
      end 
    end

    context "for description" do 
      it "must have a description" do
        new_product.description = nil
        new_product.save.should be_false
        new_product.description = "Product Description"
        new_product.save.should be_true
      end

      it "must not be an empty string" do
        new_product.description = " "
        new_product.save.should be_false
        new_product.description = "Product Description"
        new_product.save.should be_true
      end 
    end

    context "for price" do
      it "must have a price" do 
        new_product.price = nil
        new_product.save.should be_false
        new_product.price = 1.75
        new_product.save.should be_true
      end
      it "must be a number greater than zero" do 
        new_product.price = "askhdjsgsdlk"
        new_product.save.should be_false
        new_product.price = -1.75
        new_product.save.should be_false 
        new_product.price = 1.75 
        new_product.save.should be_true
      end 
    end 
    context "for photo" do 
      it "should not be required" do 
        new_product.photo_url = nil
        new_product.save.should be_true 
      end 

      it "should be a valid iamge URL if present" do 
        new_product.photo_url = "adjbgwfksl"
        new_product.save.should be_false
        new_product.photo_url = "foo.com/b.jpg"
        new_product.save.should be_false
        new_product.photo_url = "http://foo.com/b"
        new_product.save.should be_false
        new_product.photo_url = "http://foo.com/b.jpg"
        new_product.save.should be_true
      end 
    end 
  end
end
