class Order < ActiveRecord::Base
  attr_accessible :special_url, :status, :user_id
  belongs_to :user
  has_many :order_products

  validates :user_id, :presence => true, :uniqueness => true
end
