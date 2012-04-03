class Product < ActiveRecord::Base
  attr_accessible :description, :photo_url, :price, :title
  validates_presence_of :title, :description, :price
end
