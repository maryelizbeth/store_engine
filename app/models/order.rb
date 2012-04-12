require 'digest/sha1'

class Order < ActiveRecord::Base
  include AASM

  attr_accessible :special_url, :status, :user_id
  belongs_to :user
  has_many :order_products

  validates :user_id, :presence => true

  aasm :column => :status do 
    state :pending, :initial => true
    state :paid 
    state :shipped 
    state :returned 
    state :canceled 

    event :process_payment do 
      transitions :to => :paid, :from => [:pending]
    end 
    event :ship do 
      transitions :to => :shipped, :from => [:paid]
    end 
    event :return do 
      transitions :to => :returned, :from => [:shipped]
    end 
    event :cancel do 
      transitions :to => :canceled, :from => [:pending]
    end 
  end
end
