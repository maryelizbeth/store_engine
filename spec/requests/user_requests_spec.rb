
describe "User Types" do
  context "Administrator" do
    let(:admin_user) { Fabricate(:user) }
    
    it "can access the product creation screen" do
      # auto_login(admin_user)
      visit login_path
      fill_in "Email address", :with => admin_user.email_address
      fill_in "Password", :with => "test"
      click_button "Login"
      within "ul.nav" do
        page.should have_content("Create Product")
        click_link "Create Product"
        current_path.should == new_product_path
      end
    end
  end  
end