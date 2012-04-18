require 'spec_helper'

describe "User Types" do
  context "Administrator" do
    let!(:admin_user) { Fabricate(:admin_user) }
    
    before(:each) do
      login_user_post(admin_user.email_address)
    end
    
    it "can access the admin product screen" do
      within "ul.nav" do
        click_link "Products Editor"
        click_link "Create, View, & Edit Products"
        current_path.should == admin_products_path
      end
    end
    
    it "can access the admin product categories screen" do
      within "ul.nav" do
        click_link "Products Editor"
        click_link "Create, View, & Edit Product Categories"
        current_path.should == admin_product_categories_path
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
      it "can not access the admin product screen" do
        within "ul.nav" do
          page.should_not have_selector "#product_menu"
          page.should_not have_selector "#products_editor"
        end
        visit admin_products_path
        current_path.should_not == admin_products_path
      end

      it "can not access the product edit screen" do
        within "ul.nav" do
          page.should_not have_selector "#product_menu"
          page.should_not have_selector "#categories_editor"
        end
        visit admin_product_categories_path
        current_path.should_not == admin_product_categories_path
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