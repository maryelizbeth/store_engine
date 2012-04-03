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
end
