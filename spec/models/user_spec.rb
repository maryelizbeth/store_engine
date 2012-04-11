require 'spec_helper'

describe User do
  context "for attribute validations" do
    let (:new_user) { User.new(:full_name => "Test Full Name",
                      :email_address => "test_email@tfoo.com",
                      :display_name => "Test Display Name") }

    context "for full_name" do
      it "must have a full name that is not blank" do
        new_user.full_name = nil
        new_user.save.should be_false
        new_user.full_name = " "
        new_user.save.should be_false
        new_user.full_name = "Teet name"
        new_user.save.should be_true
      end
    end
    context "for email_address" do 
      it "must have a valid email address" do 
        new_user.email_address = nil 
        new_user.save.should be_false 
        new_user.email_address = " "
        new_user.save.should be_false 
        new_user.email_address = "@foo.com"
        new_user.save.should be_false 
        new_user.email_address = "asdf.at.boeing.com"
        new_user.save.should be_false
        new_user.email_address = "test_email@foo.com" 
        new_user.save.should be_true
      end 

      it "must have a unique email address" do 
        user_1 = Fabricate (:user)
        new_user.email_address = user_1.email_address
        new_user.save.should be_false
        new_user.email_address = "asdf@asdf.com"
        new_user.save.should be_true
      end 
    end 

    context "for display_name" do 
      it "is not required" do 
        new_user.display_name = nil
        new_user.save.should be_true
      end 

      it "has a length between 2 and 32 characters if present" do
        new_user.display_name = "a"
        new_user.save.should be_false 
        new_user.display_name = "a" * 33 
        new_user.save.should be_false 
        new_user.display_name = "a" * 2
        new_user.save.should be_true 
        new_user.display_name = "a" * 32
        new_user.save.should be_true
      end
    end
  end
  
  context "regarding credit cards" do
    let!(:user_1)         { Fabricate(:user) }
    let!(:user_2)         { Fabricate(:user) }
    let!(:credit_card_1)  { Fabricate(:credit_card, :user => user_1) }

    context "#credit_card" do
      it "returns the user's credit card" do
        user_1.credit_card.should == credit_card_1
      end
      
      it "returns nil if the user has no credit card" do
        user_2.credit_card.should be_nil
      end
    end
    
    context "#has_existing_credit_card?" do
      it "returns true if the user has a credit card" do
        user_1.has_existing_credit_card?.should be_true
      end
      
      it "returns false if the user has no credit card" do
        user_2.has_existing_credit_card?.should be_false
      end
    end
  end
  
  context "#admin?" do
    let!(:admin_user)   { Fabricate(:admin_user) }
    let!(:normal_user)  { Fabricate(:user) }
    
    it "returns true if user is an admin" do
      admin_user.admin?.should be_true
    end
    
    it "returns false if user is not an admin" do
      normal_user.admin?.should be_false
    end
  end
  
  context "for billing addresses" do
    let!(:user_1)             { Fabricate(:user) }
    let!(:billing_address_1)  { Fabricate(:billing_address, :user => user_1) }
    let!(:user_2)             { Fabricate(:user) }
    
    context "#has_existing_billing_address?" do
      it "returns true if the user has a billing address" do
        user_1.has_existing_billing_address?.should be_true
      end
    
      it "returns false if the user has no billing address" do
        user_2.has_existing_billing_address?.should be_false
      end
    end
    
    context "#billing_address" do
      it "returns the billing address if the user has one" do
        user_1.billing_address.should == billing_address_1
      end
      
      it "returns nil if the user has no billing address" do
        user_2.billing_address.should be_nil
      end
    end
  end
  
  context "for shipping addresses" do
    let!(:user_1)             { Fabricate(:user) }
    let!(:shipping_address_1)  { Fabricate(:shipping_address, :user => user_1) }
    let!(:user_2)             { Fabricate(:user) }
    
    context "#has_existing_shipping_address?" do
      it "returns true if the user has a billing address" do
        user_1.has_existing_shipping_address?.should be_true
      end
    
      it "returns false if the user has no shipping address" do
        user_2.has_existing_shipping_address?.should be_false
      end
    end
    
    context "#shipping_address" do
      it "returns the shipping address if the user has one" do
        user_1.shipping_address.should == shipping_address_1
      end
      
      it "returns nil if the user has no shipping address" do
        user_2.shipping_address.should be_nil
      end
    end
  end
end
