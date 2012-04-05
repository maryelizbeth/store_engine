require 'spec_helper'

describe OrderController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'process'" do
    it "returns http success" do
      get 'process'
      response.should be_success
    end
  end

end
