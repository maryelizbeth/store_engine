require 'spec_helper'

# Shopper Does Bad Things

feature "Shopper Does Bad Things", :js => true, :acceptance => true do
  let!(:matt_yoho)    { Fabricate(:user_matt) }

  let!(:product_1)  { Fabricate(:product, :price => 1.11) }
  let!(:product_2)  { Fabricate(:product, :price => 2.22) }
  let!(:product_3)  { Fabricate(:product, :price => 3.33) }
  let!(:product_4)  { Fabricate(:product, :price => 4.44) }
  let!(:products)   { [product_1, product_2, product_3, product_4]}
  let!(:pc_1)       { Fabricate(:product_category) }
  let!(:pc_2)       { Fabricate(:product_category) }
  let!(:order_1)    { Fabricate(:order, :user_id => matt_yoho.id, :status => "paid") }
  let!(:order_product_1)  { Fabricate(:order_product, :order => order_1, :product => product_1, :price => product_1.price)}
  
  before(:each) do
    product_1.product_categories << pc_2
    product_2.product_categories << pc_2
    product_3.product_categories << pc_1
    product_4.product_categories << pc_2
    login_user(matt_yoho.email_address)
  end
  
  context "Shopper tries to add retired item to cart" do
    before(:each) do
      product_1.update_attribute(:active, false)
      find("#view_past_orders").click
      within "#orders" do
        click_link "View"
      end
      click_link product_1.title
    end
    
    it "informs Matt Yoho that the product is retired" do
      page.should have_selector ".retired"
      find("#index-prod-title").text.should have_content "- RETIRED"
    end
    
    it "can not be added to a cart" do
      page.should_not have_selector "add_to_cart_button"
      page.should_not have_selector "two_click_checkout"
    end
  end
  
  context "Shopper tries to access an order page while not authenticated" do
    let!(:user_1)   { Fabricate(:user) }
    
    before(:each) do
      find("#logout").click
      visit order_path(matt_yoho.orders.first)
    end
    
    it "does not allow me to view the page" do
      current_path.should == login_path
      fill_in "Email", :with => user_1.email_address
      fill_in "Password", :with => "hungry"
      click_button "Login"
      current_path.should == root_path
      page.should have_content "Could not find order"
    end
  end
end