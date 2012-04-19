class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :addresses
  has_many :credit_cards
  has_many :orders
  attr_accessible :display_name, :email_address, :full_name,
                  :password, :password_confirmation
  validates :full_name, :presence =>
  { :message => "Full name can not be blank.  Please enter your full name." }
  validates :display_name, :allow_nil => true,
            :length => { :minimum => 2, :maximum => 32 }
  validates :email_address, :presence => true,
            :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/},
            :uniqueness => true
  validates_length_of :password, :minimum => 3,
                      :message => "password must be at least 3 characters long",
                      :if => :password
  validates_confirmation_of :password, :message => "should match confirmation",
                            :if => :password

  def admin?
    is_admin
  end

  def has_existing_credit_card?
    credit_cards.count > 0
  end

  def has_existing_billing_address?
    addresses.find_by_address_type("billing")
  end

  def has_existing_shipping_address?
    addresses.find_by_address_type("shipping")
  end

  def can_two_click_checkout?
    has_existing_credit_card? &&
    has_existing_billing_address? &&
    has_existing_shipping_address?
  end

  def credit_card
    credit_cards.first if credit_cards
  end

  def billing_address
    addresses.find_by_address_type("billing")
  end

  def shipping_address
    addresses.find_by_address_type("shipping")
  end
end