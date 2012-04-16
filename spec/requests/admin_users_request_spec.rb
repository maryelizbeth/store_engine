require 'spec_helper'

describe "Admin Users request" do
  context "when logged in as an admin user" do
    let!(:admin_user)     { Fabricate(:admin_user) }
    
    before(:each) do
      login_user_post(admin_user.email_address)
    end
    
    context "with existing users in the system" do
      let!(:user_1)   { Fabricate(:user) }
      let!(:user_2)   { Fabricate(:user) }
      let!(:user_3)   { Fabricate(:user) }
      let!(:users)    { [user_1, user_2, user_3] }
      
      context "when visiting the index page" do
        before(:each) do
          visit admin_users_path
        end
        
        it "displays the id for each user" do
          users.each do |user|
            find("#user_#{user.id}_id").text.should have_content user.id
          end
        end
        
        it "displays the full name for each user" do
          users.each do |user|
            find("#user_#{user.id}_full_name").text.should have_content user.full_name
          end
        end
        
        it "displays the display name for each user" do
          users.each do |user|
            find("#user_#{user.id}_display_name").text.should have_content user.display_name
          end
        end
        
        it "displays the email address for each user" do
          users.each do |user|
            find("#user_#{user.id}_email_address").text.should have_content user.email_address
          end
        end
        
        context "when viewing a specific user's admin user page" do
          before(:each) do
            find("#user_#{user_2.id}_view").click
          end
          
          it "displays the user's full name for each user" do
            find("#full_name").text.should have_content user_2.full_name
          end

          it "displays the user's display name for each user" do
            find("#display_name").text.should have_content user_2.display_name
          end

          it "displays the user's email address" do
            find("#email_address").text.should have_content user_2.email_address
          end
        end
      end
    end
  end
end