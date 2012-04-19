require 'spec_helper'

describe CreditCard do
  let!(:user)               { Fabricate(:user) }
  let!(:credit_card_1)      { Fabricate(:credit_card, :user => user, :card_number => "1234567890123456") }
  
  context "#masked_number" do
    it "replaces all but the last four characters with Xs" do
      credit_card_1.masked_number.should == "XXXXXXXXXXXX3456"
    end
  end
end
