class CreditCard < ActiveRecord::Base
  attr_accessible :card_number, :ccv, :expiration_month, :expiration_year
  belongs_to :user
  
  validates :card_number,       :length => { :in => 13..16 }
  validates :expiration_month,  :length => { :in => 1..2 }
  validates :expiration_year,   :length => { :is => 4 }
  validates :ccv,               :length => { :is => 3 }
  
  def masked_number
    "X" * (card_number.length - 4) + card_number[-4,4]
  end
end
