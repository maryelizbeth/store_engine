require 'spec_helper'

describe "User Types" do
  context "Administrator" do
    let!(:admin_user) { Fabricate(:admin_user) }
    
    it "can access the product creation screen" do
      login_user_post(admin_user.email_address)
      within "ul.nav" do
        click_link "Products Editor"
        click_link "Create Product"
        current_path.should == new_admin_product_path
      end
    end
  end
  
  context "User" do
    let!(:user)     { Fabricate(:user) }
    let!(:product)  { Fabricate(:product) }
    
    it "can not access the product creation screen" do
      login_user_post(user.email_address)
      within "ul.nav" do
        page.should_not have_selector "#product_menu"
        page.should_not have_selector "#create_product"
      end
      visit new_admin_product_path
      current_path.should_not == new_admin_product_path
    end

    it "can not access the product edit screen" do
      login_user_post(user.email_address)
      within "ul.nav" do
        page.should_not have_selector "#product_menu"
        page.should_not have_selector "#edit_product"
      end
      visit edit_admin_product_path(product)
      current_path.should_not == edit_admin_product_path(product)
    end
  end
end