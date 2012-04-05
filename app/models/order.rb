require 'digest/sha1'

class Order < ActiveRecord::Base
  include AASM

  attr_accessible :special_url, :status, :user_id
  belongs_to :user
  has_many :order_products

  validates :user_id, :presence => true, :uniqueness => true

  aasm :column => :status do 
    state :pending, :initial => true
    state :paid 
    state :shipped 
    state :returned 
    state :cancelled 

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
      transitions :to => :cancelled, :from => [:pending, :cart]
    end 
  end
  
  def create_special_url
    self.special_url = "/store?order=" + Digest::SHA1.hexdigest("#{Time.now.to_i}")
  end
end
