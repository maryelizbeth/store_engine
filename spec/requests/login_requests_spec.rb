require 'spec_helper'

describe "Login Requests" do
  let!(:existing_user) { Fabricate(:login_test_user) }
  
  context "New User" do
    it "logs the user in immediately after creating an account" do
      email_address = "test_user_#{Time.now.to_i}@lsqa.net"
      visit new_user_path
      fill_in "Full name", :with => "Test User"
      fill_in "Display name", :with => "test_user"
      fill_in "Email address", :with => email_address
      fill_in "Password", :with => "test"
      fill_in "Password confirmation", :with => "test"
      click_button "Create User"
      within "#notice" do
        page.should have_content "User was successfully created."
      end
      within "ul.nav" do
        page.should have_content "Logout"
      end
    end
  end
  
  context "Existing User" do
    it "logs the user in immediately after creating an account" do
      visit login_path
      fill_in "Email address", :with => existing_user.email_address
      fill_in "Password", :with => "test"
      click_button "Login"
      within "#notice" do
        page.should have_content "Login successful."
      end
      within "ul.nav" do
        page.should have_content "Logout"
      end
    end
  end
  
  context "Bad User" do
    it "does not log me in if I enter a bad email address" do
      visit login_path
      fill_in "Email address", :with => "existing_user.email_address@blah.blah"
      fill_in "Password", :with => "test"
      click_button "Login"
      within "#alert" do
        page.should have_content "Login failed."
      end
      within "ul.nav" do
        page.should_not have_content "Logout"
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
        page.should_not have_content "Logout"
      end
    end
  end
end