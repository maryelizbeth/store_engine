require 'spec_helper'

describe "Product create" do
  context "for authenticated admin users" do
    let!(:admin_user) { Fabricate(:user_chad) }
    let!(:product_category_1)  { Fabricate(:product_category) }
    let!(:product_category_2)  { Fabricate(:product_category) }
    
    before(:each) do
      login_user_post(admin_user.email_address)
      visit new_product_path
    end
  
    context "using valid attributes" do
      let!(:title)        { Faker::Lorem.words(1).first }
      let!(:description)  { Faker::Lorem.paragraphs(1).first }
      let!(:price)        { "1.43" }
      
      before(:each) do          
        fill_in "Title", :with => title
        fill_in "Description", :with => description
        fill_in "Price", :with => price
      end
      
      context "after entering a photo url" do
        let!(:url) { "http://a1.ak.lscdn.net/deals/images/refresh/branding/livingsocial-logo.png" }

        before(:each) do
          fill_in "Photo url", :with => url
          within ".form-actions" do
            click_link_or_button "Create Product"
          end
        end

        context "a new product is created" do
          it "takes me to the show page for the newly created product" do
            current_path.should == product_path(Product.all.last)
          end

          it "informs me that the product creation was a success" do
            page.should have_content "Product was successfully created."
          end

          it "has the correct title" do
            within "#product_title" do
              page.should have_content title
            end
          end

          it "has the correct description" do
            within "#product_description" do
              page.should have_content description
            end
          end

          it "has the correct price" do
            within "#product_price" do
              page.should have_content price
            end
          end

          it "has the correct photo url" do
            within "#product_photo_url" do
              page.should have_content url
            end
          end

          it "is active by default" do
            page.should have_selector ".icon-ok"
          end
        end
      end
      
      context "with no photo url entered" do
        before(:each) do
          fill_in "Photo url", :with => ""
          within ".form-actions" do
            click_link_or_button "Create Product"
          end
        end
        
        context "a new product is created" do
          it "takes me to the show page for the newly created product" do
            current_path.should == product_path(Product.all.last)
          end

          it "informs me that the product creation was a success" do
            page.should have_content "Product was successfully created."
          end
          
          it "has no photo url" do
            within "#product_photo_url" do
              page.should have_content "None"
            end
          end
        end
      end

      context "when selecting categories" do
        before(:each) do
          select(product_category_2.name, :from => "product_product_category_ids")
          within ".form-actions" do
            click_link_or_button "Create Product"
          end
        end
        
        context "a new product is created" do
          it "takes me to the show page for the newly created product" do
            current_path.should == product_path(Product.all.last)
          end

          it "informs me that the product creation was a success" do
            page.should have_content "Product was successfully created."
          end
          
          it "has been assigned to the correct category" do
            within "#product_categories" do
              page.should_not have_content product_category_1.name
              page.should have_content product_category_2.name
            end
          end
        end
        
      end
    end
  
    context "using invalid attributes" do
      let!(:title)        { Faker::Lorem.words(1).first }
      let!(:description)  { Faker::Lorem.paragraphs(1).first }
      let!(:price)        { "1.43" }
      let!(:url) { "http://a1.ak.lscdn.net/deals/images/refresh/branding/livingsocial-logo.png" }

      before(:each) do          
        fill_in "Title", :with => title
        fill_in "Description", :with => description
        fill_in "Price", :with => price
        fill_in "Photo url", :with => url
      end
      
      context "after not entering a title" do
        before(:each) do
          fill_in "Title", :with => ""
          within ".form-actions" do
            click_link_or_button "Create Product"
          end
        end

        context "a new product is not created" do
          it "takes me back to the create product page" do
            current_path.should == products_path()
          end

          it "informs me that there was a problem with title" do
            page.should have_content "Title can't be blank"
          end
        end
      end
      
      context "after not entering a description" do
        before(:each) do
          fill_in "Description", :with => ""
          within ".form-actions" do
            click_link_or_button "Create Product"
          end
        end

        context "a new product is not created" do
          it "takes me back to the create product page" do
            current_path.should == products_path()
          end

          it "informs me that there was a problem with description" do
            page.should have_content "Description can't be blank"
          end
        end
      end
      
      context "after not entering a price" do
        before(:each) do
          fill_in "Price", :with => ""
          within ".form-actions" do
            click_link_or_button "Create Product"
          end
        end

        context "a new product is not created" do
          it "takes me back to the create product page" do
            current_path.should == products_path()
          end

          it "informs me that there was a problem with price" do
            page.should have_content "Price can't be blank"
          end
        end
      end
    end
  end
end