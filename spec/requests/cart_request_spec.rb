require 'spec_helper'

describe "Cart Requests" do  
  context "there are products in the store" do
    let!(:product_1) { Fabricate(:product, :price => 3.21) }

    context "on the store index page" do
      before(:each) do
        visit root_path
        click_link_or_button "Add to Cart"
      end
      
      context "if the product is not yet in the cart" do
        it "can add one product to the cart" do
          within "#cart_item_#{product_1.id}" do
            find(".quantity").value.should == "1"
            find(".cart_item_total").text.should == "$3.21"
          end
        end

        it "displays the correct order total" do
          within ".order-total" do
           page.should have_content "$3.21"
         end
        end
      end
      
      context "if the product is already in the cart" do
        before(:each) do
          visit root_path
          click_link_or_button "Add to Cart"
        end
        
        it "increments the quantity of the product to the cart" do
          within "#cart_item_#{product_1.id}" do
            find(".quantity").value.should == "2"
          end
        end
      end
    end

    context "on the cart show page" do
      context "and the cart has products" do

        before(:each) do
          visit root_path
          within "#store_product_#{product_1.id}_add_to_cart" do
            click_link_or_button "Add to Cart"
          end
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
        
        context "when clearing a cart" do
          let!(:product_2)  { Fabricate(:product, :price => 3.21) }
          let!(:products)   { [product_1, product_2] }
          
          before(:each) do
            visit root_path
            within "#store_product_#{product_2.id}_add_to_cart" do
              click_link_or_button "Add to Cart"
            end
          end
          
          it "removes all items" do
            find("#empty_cart").click
            current_path.should == cart_show_path
            find("#notice").text.should == "Your cart has been cleared."
            products.each { |product| page.should_not have_selector "#cart_item_#{product.id}" }
          end
        end
      end
    end
    
    context "attempting to add a retired product" do
      context "on the product show page" do
        before(:each) do
          visit product_path(product_1)
          product_1.update_attribute(:active, false)
        end
        
        it "does not add the item to the cart" do
          expect { find("#add_to_cart_button").click }.to_not change{ CartProduct.count }.by(1)
        end
        
        it "redirects the user to back to the product page" do
          find("#add_to_cart_button").click
          current_path.should == product_path(product_1)
        end
        
        it "informs the user that the item has been retired" do
          find("#add_to_cart_button").click
          page.should have_content "This product is retired."
        end
      end
    end
  end
end