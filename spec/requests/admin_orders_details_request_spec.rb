require 'spec_helper'

describe "Admin Orders Details flyout" do
  context "" do
    let!(:admin_user)   { Fabricate(:admin_user) }

    before(:each) do
      login_user(admin_user.email_address)
    end

    context "with existing orders" do
      let!(:user_1)     { Fabricate(:user) }
      let!(:user_2)     { Fabricate(:user) }
      let!(:product_1)  { Fabricate(:product) }
      let!(:product_2)  { Fabricate(:product) }
      let!(:order_1)    { Fabricate(:order, :user_id => user_1.id) }
      let!(:order_product_1)  { Fabricate(:order_product, :order => order_1, :product => product_1, :price => product_1.price) }
      let!(:order_2)    { Fabricate(:order, :user_id => user_2.id) }
      let!(:order_product_2)  { Fabricate(:order_product, :order => order_2, :product => product_1, :price => product_1.price, :quantity => 3) }
      let!(:order_product_3)  { Fabricate(:order_product, :order => order_2, :product => product_2, :price => product_2.price) }
      let!(:purchased_items)  { [order_product_2, order_product_3] }
      let!(:order_3)    { Fabricate(:order, :user_id => user_1.id) }
      let!(:order_product_4)  { Fabricate(:order_product, :order => order_3, :product => product_2, :price => product_2.price) }
      let!(:orders)     { [order_1, order_2, order_3] }

      context "on the admin orders index page" do
        before(:each) do
          visit admin_orders_path
        end

        context "in the details flyout for an order", :js => true do
          before(:each) do
            find("#order_#{order_2.id}_details_control").click
          end

          it "displays the order date and time" do
            find("#order_#{order_2.id}_details_datetime").text.should have_content order_2.placed_at
          end

          it "displays the purchaser's email address" do
            find("#order_#{order_2.id}_details_user_email_address").text.should have_content order_2.user.email_address
          end

          it "displays the total for the order" do
            find("#order_#{order_2.id}_details_total").text.should have_content number_to_currency(order_2.total)
          end

          context "for the items purchased" do
            it "displays the correct information" do
              purchased_items.each do |pi|
                find("#order_item_#{pi.id}_title").text.should have_content pi.product.title
                find("#order_item_#{pi.id}_price").text.should have_content number_to_currency(pi.price)
                find("#order_item_#{pi.id}_quantity").text.should have_content pi.quantity
                find("#order_item_#{pi.id}_total").text.should have_content number_to_currency(pi.total)
              end
            end
          end
        end
      end
    end
  end
end