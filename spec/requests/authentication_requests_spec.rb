require 'spec_helper'

describe "Login Requests" do
  let!(:existing_user) { Fabricate(:login_test_user) }

  context "Unauthenticated user" do
    context "New User" do
      it "logs the user in immediately after creating an account" do
        email_address = "test_user_#{Time.now.to_i}@lsqa.net"
        visit new_user_path
        fill_in "Full name", :with => "Test User"
        fill_in "Display name", :with => "test_user"
        fill_in "Email address", :with => email_address
        fill_in "Password", :with => DEFAULT_USER_PASSWORD
        fill_in "Password confirmation", :with => DEFAULT_USER_PASSWORD
        click_button "Create User"
        within "#notice" do
          page.should have_content "User was successfully created."
        end
        within "ul.nav" do
          page.should_not have_selector "#login"
          page.should_not have_selector "#create_account"
          page.should     have_selector "#logout"
        end
      end
    
      it "does not log in if account creation fails" do
        email_address = "test_user_#{Time.now.to_i}@lsqa.net"
        visit new_user_path
        fill_in "Full name", :with => "Test User"
        fill_in "Display name", :with => "test_user"
        fill_in "Email address", :with => email_address
        fill_in "Password", :with => DEFAULT_USER_PASSWORD
        fill_in "Password confirmation", :with => DEFAULT_USER_PASSWORD + "y"
        click_button "Create User"
        within "ul.nav" do
          page.should     have_selector "#login"
          page.should     have_selector "#create_account"
          page.should_not have_selector "#logout"
        end
      end
    end
  
    context "Existing User" do
      it "logs the user in immediately after creating an account" do
        visit login_path
        fill_in "Email address", :with => existing_user.email_address
        fill_in "Password", :with => DEFAULT_USER_PASSWORD
        click_button "Login"
        within "#notice" do
          page.should have_content "Login successful."
        end
        within "ul.nav" do
          page.should_not have_selector "#login"
          page.should_not have_selector "#create_account"
          page.should     have_selector "#logout"
        end
      end
    end
  
    context "Bad User" do
      it "does not log me in if I enter a bad email address" do
        visit login_path
        fill_in "Email address", :with => "existing_user.email_address@blah.blah"
        fill_in "Password", :with => DEFAULT_USER_PASSWORD
        click_button "Login"
        within "#alert" do
          page.should have_content "Login failed."
        end
        within "ul.nav" do
          page.should     have_selector "#login"
          page.should     have_selector "#create_account"
          page.should_not have_selector "#logout"
        end
      end
    
      it "does not log me in if I enter a bad password" do
        visit login_path
        fill_in "Email address", :with => existing_user.email_address
        fill_in "Password", :with => "testa"
        click_button "Login"
        within "#alert" do
          page.should have_content "Login failed."
        end
        within "ul.nav" do
          page.should     have_selector "#login"
          page.should     have_selector "#create_account"
          page.should_not have_selector "#logout"
        end
      end
    end
  
    context "trying to access an area that requires authentication" do
      let!(:order)  { Fabricate(:order) }
      
      before(:each) do
        visit order_path(order)
      end
      
      it "takes me to the login page" do
        current_path.should == login_path
      end
      
      it "lets me know that I need to login" do
        page.should have_content "Please login first."
      end
    end
  end
  
  context "Authenticated user" do
    it "logs out of the site" do
      login_user_post(existing_user.email_address)
      within "ul.nav" do
        find("#logout").click
      end
      within "ul.nav" do
        page.should     have_selector "#login"
        page.should     have_selector "#create_account"
        page.should_not have_selector "#logout"
      end
    end
  end
end