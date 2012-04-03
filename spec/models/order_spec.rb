require 'spec_helper'

describe Order do
  context "for attribute validations" do
    let (:new_order) { Order.new }
    let (:user_1) { Fabricate(:user) }

    context "for model relationships" do
      it "must belong to a user" do
        new_order.save.should be_false
        new_order.user = user_1
        new_order.save.should be_true
      end

      it "must be for one or more of one or more products currently being sold"
    end
  end
end
