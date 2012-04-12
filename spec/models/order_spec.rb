require 'spec_helper'

describe Order do
  context "for attribute validations" do
    let!(:user_1)     { Fabricate(:user) }
    let!(:order_1)    { Fabricate(:order, :user => user_1) }
    
    context "for model relationships" do
      let!(:new_order)  { Order.new }
      it "must belong to a user" do
        new_order.save.should be_false
        new_order.user = user_1
        new_order.save.should be_true
      end

      it "must be for one or more of one or more products currently being sold"
      
    end
    
    context "for state transitions" do
      it "starts in pending state" do
        order_1.status.should == "pending"
      end
      
      it "transitions from pending to paid when payment is processed" do
        order_1.process_payment
        order_1.status.should == "paid"
      end
      
      it "transitions from pending to canceled when canceled" do
        order_1.cancel
        order_1.status.should == "canceled"
      end
      
      it "transitions from paid to shipped when shipped" do
        order_1.process_payment
        order_1.ship
        order_1.status.should == "shipped"
      end
      
      it "transitions from shipped to returned when returned by customer" do
        order_1.process_payment
        order_1.ship
        order_1.return
        order_1.status.should == "returned"
      end
    end
  end
end
