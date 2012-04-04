class Categorization < ActiveRecord::Base
  attr_accessible :product_category_id, :product_id
  has_one :product
  has_one :product_category
  belongs_to :product
  belongs_to :product_category
end
