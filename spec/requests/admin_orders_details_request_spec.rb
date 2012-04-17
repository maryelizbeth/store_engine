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
      let!(:order_product_2)  { Fabricate(:order_product, :order => order_2, :product => product_2, :price => product_2.price) }
      let!(:order_3)    { Fabricate(:order, :user_id => user_1.id) }
      let!(:order_product_3)  { Fabricate(:order_product, :order => order_3, :product => product_2, :price => product_2.price) }
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
            find("#order_#{order_2.id}_details_datetime").text.should have_content order_2.created_at
          end

          it "displays the purchaser's full name" do
            find("#order_#{order_2.id}_details_user_full_name").text.should have_content order_2.user.full_name
          end

          it "displays the purchaser's email address" do
            find("#order_#{order_2.id}_details_user_email_address").text.should have_content order_2.user.email_address
          end

          it "displays the total for the order" do
            find("#order_#{order_2.id}_details_total").text.should have_content number_to_currency(order_2.total)
          end

          it "displays the status of the order" do
            find("#order_#{order_2.id}_details_status").text.should have_content order_2.status
          end
        end
      end
    end
  end
end