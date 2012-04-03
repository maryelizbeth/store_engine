class Product < ActiveRecord::Base
  attr_accessible :description, :photo_url, :price, :title

  validates_presence_of :title, :description
  validates_uniqueness_of :title 
  validates :price, :numericality => { :greater_than => 0 }, :presence => true
  validates :photo_url, :allow_nil => true, :format => { :with => /^https?:\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?(?:png|jpe?g|gif|svg)$/ }
end
