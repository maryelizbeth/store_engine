require 'digest/sha1'

class Order < ActiveRecord::Base
  before_create :create_special_url
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
  
  def transition(method_name)
    case method_name
      when "process-payment"  then self.process_payment
      when "ship"             then self.ship
      when "return"           then self.return
      when "cancel"           then self.cancel
    end
    self.save
  end
  
  def total
    order_products.sum { |op| op.total }
  end

  def placed_at
    created_at.strftime("%Y-%m-%d %H:%M UTC")
  end

  private

  def create_special_url
    self.special_url = Digest::SHA1.hexdigest("#{ Time.now.to_i.to_s + user.full_name + rand(1..10000).to_s }")
  end
end
