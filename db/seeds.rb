image_base = "http://severe-beach-6680.herokuapp.com/images/image"

(0..2).each do |a|
  pc = Fabricate(:product_category)
  (1..4).each { |b| Fabricate(:product, :photo_url => "#{image_base}#{(a*4+b)}.jpg").product_categories << pc }
end

5.times { Fabricate(:user) }

Fabricate(:login_test_user)
Fabricate(:admin_user)
Fabricate(:user_matt)
Fabricate(:user_jeff)
Fabricate(:user_chad)

user = Fabricate(:full_user)
user.credit_cards << Fabricate(:credit_card)
user.addresses    << Fabricate(:billing_address)
user.addresses    << Fabricate(:shipping_address)