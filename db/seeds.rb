(0..2).each do |a|
  pc = Fabricate(:product_category)
  (1..3).each { |b| Fabricate(:product).product_categories << pc }
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