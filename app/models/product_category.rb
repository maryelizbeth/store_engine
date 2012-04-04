class ProductCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :categorizations 
  has_many :products, :through => :categorizations
  validate_uniqueness_of :name
end
