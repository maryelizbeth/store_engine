class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street_1, :street_2, :zip_code, :address_type
  belongs_to :user
  
  validates :address_type, :presence => true
  validates :street_1, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true, :length => { :is => 2 }
  validates :zip_code, :presence => true
end
