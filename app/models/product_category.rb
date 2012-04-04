class ProductCategory < ActiveRecord::Base
  attr_accessible :name, :product_ids
  has_many :categorizations 
  has_many :products, :through => :categorizations
  validates_uniqueness_of :name
end
