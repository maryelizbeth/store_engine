class ProductCategory < ActiveRecord::Base
  attr_accessible :name, :product_ids
  has_many :categorizations 
  has_many :products, :through => :categorizations
  validates :name, :presence => true, :uniqueness => true
  
  def active_products
    products.find(:all, :conditions => ["active = ?", true])
  end
  
  def product_count
    products.count
  end
end
