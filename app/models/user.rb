class User < ActiveRecord::Base
  attr_accessible :display_name, :email_address, :full_name
  validates :full_name, :presence => true
  validates :display_name, :allow_nil => true, :length => { :minimum => 2, :maximum => 32 }
  validates :email_address, :presence => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/}, :uniqueness => true
end
