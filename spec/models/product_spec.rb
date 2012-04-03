require 'spec_helper'

describe Product do
  context "for attribute validations" do
    let (:new_product) { Product.new(:title => "Product Title",
                          :description => "Product Description",
                          :price => 1.75) }

    it "must have a title" do
      new_product.title = nil
      new_product.save.should be_false
      new_product.title = "Product Title"
      new_product.save.should be_true
    end

    it "must have a description" do
      new_product.description = nil
      new_product.save.should be_false
      new_product.description = "Product Description"
      new_product.save.should be_true
    end

    it "must have a price" do 
      new_product.price = nil
      new_product.save.should be_false
      new_product.price = 1.75
      new_product.save.should be_true
    end 
  end
end
