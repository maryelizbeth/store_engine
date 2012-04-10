class CreditCard < ActiveRecord::Base
  attr_accessible :card_number, :ccv, :expiration_month, :expiration_year
  belongs_to :user
end
