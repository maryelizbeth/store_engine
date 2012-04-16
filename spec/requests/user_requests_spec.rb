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
  
  context "Authenticated User" do
    let!(:user)     { Fabricate(:user) }
    let!(:product)  { Fabricate(:product) }
    
    before(:each) do
      login_user_post(user.email_address)
    end
    
    context "for admin features in nav" do
      it "can not access the product creation screen" do
        within "ul.nav" do
          page.should_not have_selector "#product_menu"
          page.should_not have_selector "#create_product"
        end
        visit new_admin_product_path
        current_path.should_not == new_admin_product_path
      end

      it "can not access the product edit screen" do
        within "ul.nav" do
          page.should_not have_selector "#product_menu"
          page.should_not have_selector "#edit_product"
        end
        visit edit_admin_product_path(product)
        current_path.should_not == edit_admin_product_path(product)
      end
    end
    
    context "for user show pages" do
      context "when visiting your own user show page" do
        before(:each) do
          visit user_path(user)
        end
        
        it "should allow access" do
          current_path.should == user_path(user)
          page.should have_selector "#email_address"
        end
      end
      
      context "when visiting someone else's user show page" do
        let!(:user_2)   { Fabricate(:user) }
        
        before(:each) do
          visit user_path(user_2)
        end
        
        it "should not allow access" do
          current_path.should_not == user_path(user)
          page.should_not have_selector "#email_address"
        end
      end
    end
  end
end