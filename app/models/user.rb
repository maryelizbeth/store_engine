class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :display_name, :email_address, :full_name, :password, :password_confirmation
  validates :full_name, :presence => true
  validates :display_name, :allow_nil => true, :length => { :minimum => 2, :maximum => 32 }
  validates :email_address, :presence => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/}, :uniqueness => true
  validates_length_of :password, :minimum => 3, :message => "password must be at least 3 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password
end
