require 'spec_helper'

describe "Cart Requests" do  
  context "there are products in the store" do
    let!(:product_1) { Fabricate(:product, :price => 3.21) }

    context "on the store index page" do
      before(:each) do
        visit root_path
        click_link_or_button "Add to Cart"
      end

      it "can add one product to the cart" do
        within "#cart_item_#{product_1.id}" do
          find(".quantity").value.should == "1"
          find(".cart_item_total").text.should == "$3.21"
        end
      end

      it "displays the correct order total" do
        find("#order-total").text.should == "$3.21"
      end
    end

    context "on the cart show page" do
      context "and the cart has products" do

        before(:each) do
          visit root_path
          click_link_or_button "Add to Cart"
        end

        it "updates the quantity for a product if the entered quantity is > 0" do
          quantity = 5

          within "#cart_item_#{product_1.id}" do
            find(".quantity").set(quantity)
          end
          within ".cart-form-actions" do
            find("input#update_cart").click
          end
          within "#notice" do
            page.should have_content "Cart updated."
          end
          within "#cart_item_#{product_1.id}" do
            find(".cart_item_total").text.should == "$" + (quantity * product_1.price).to_s
            find(".quantity").value.should == quantity.to_s
          end
        end

        it "removes a product from the cart on update if the entered quantity is 0" do
          quantity = 0

          within "#cart_item_#{product_1.id}" do
            find(".quantity").set(quantity)
          end
          within ".cart-form-actions" do
            find("input#update_cart").click
          end
          within "#notice" do
            page.should have_content "Cart updated."
          end
          page.should_not have_selector "#cart_item_#{product_1.id}"
        end

        it "removes a product from the cart after clicking 'remove item'" do
          within "#cart_item_#{product_1.id}" do
            find(".icon-remove").click
          end
          within "#notice" do
            page.should have_content "'#{product_1.title}' was removed from your cart."
          end
          page.should_not have_selector "#cart_item_#{product_1.id}"
        end
      end
    end
  end
end