require 'spec_helper'

describe "User Types" do
  context "Administrator" do
    let!(:admin_user) { Fabricate(:admin_user) }
    
    it "can access the product creation screen" do
      login_user_post(admin_user.email_address)
      within "ul.nav" do
        click_link "Products Editor"
        click_link "Create Product"
        current_path.should == new_product_path
      end
    end
  end  
end