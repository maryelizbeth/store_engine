require 'spec_helper'

# Admin Puts Product Through Lifecycle

feature "Admin Puts Product Through Lifecycle", :js => true, :acceptance => true do
  let!(:the_chad)    { Fabricate(:user_chad) }
  
  before(:each) do
    login_user(the_chad.email_address)
  end
  
  context "Admin creates product" do
    before(:each) do
      visit admin_products_path
      find("#create_product").click
      
      @title = Faker::Lorem.words(1).first
      @description = Faker::Lorem.paragraphs(1).first
      @price = "1.43"
      @photo_url = "http://severe-beach-6680.herokuapp.com/images/image11.jpg"
      fill_in "Title", :with => @title
      fill_in "Description", :with => @description
      fill_in "Price", :with => @price
      fill_in "Photo url", :with => @photo_url
      click_link_or_button "Create Product"
    end
    
    it "displays the correct product & product info" do
      find("#product_title").text.should have_content @title
      find("#product_description").text.should have_content @description
      find("#product_price").text.should have_content number_to_currency(@price)
      find("#product_photo_url").text.should have_content @photo_url
    end
    
    context "Admin creates category" do
      before(:each) do
        visit admin_product_categories_path
        find("#create_product_category").click
        fill_in "Name", :with => "Very Unique Name"
        click_button "Create Product category"
        @new_product_category = ProductCategory.last
      end
      
      it "displays the new category with name" do
        current_path.should == admin_product_category_path(@new_product_category)
        find("#product_category_name").text.should have_content "Very Unique Name"
      end
      
      context "Admin adds product to category" do
        before(:each) do
          @product = Product.last
          @product_category = ProductCategory.last
          visit edit_admin_product_path(@product)
          select @product_category.name, :from => "product_product_category_ids"
          click_button "Update Product"
          visit root_path
          select @product_category.name, :from => "category_id"
        end
        
        it "displays the product" do
          page.should have_selector "#store_product_#{@product.id}_image"
          find("#store_product_#{@product.id}_title").text.should have_content @product.title
          find("#store_product_#{@product.id}_price").text.should have_content number_to_currency(@product.price)
        end
      end
    end
  end
  
  context "Retiring a product" do
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
      visit edit_admin_product_path(product_1)
      uncheck "product_active"
      click_button "Update Product"
      find("#logout").click
      visit root_path
    end
    
    it "does not display the retired product" do
      page.should_not have_selector "#store_product_#{product_1.id}_image"
    end
  end
end