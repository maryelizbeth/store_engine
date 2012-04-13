require 'spec_helper'

describe "Ajax add to cart" do
  context "when adding items to a cart", :js => true do
    let!(:product_1)    { Fabricate(:product) }
    
    before(:each) do
      visit root_path
      within "#store_product_#{product_1.id}_add_to_cart" do
        click_link "Add to Cart"
      end
    end
    
    it "add one item to my cart indicator" do
      within "#cart_info" do
        page.should have_content "(1 |"
      end
    end
    
    it "displays the total cart amount in my cart indicator" do
      within "#cart_info" do
        page.should have_content "#{number_to_currency(product_1.price)}"
      end
    end
    
    it "notifies me that the product was added to my cart" do
      within "#notice" do
        page.should have_content "'#{product_1.title}' was successfully added to your cart."
      end
    end
  end
end