require 'spec_helper'

describe PagesController, "to githubs" do
  it "should redirect to index with a notice on successful save" do
    get 'to_github'
    response.should redirect_to "https://github.com/maryelizbeth/store_engine/"
  end
end