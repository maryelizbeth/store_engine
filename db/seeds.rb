(0..2).each do |a|
  pc = Fabricate(:product_category)
  (1..3).each { |b| Fabricate(:product).product_categories << pc }
end

5.times { Fabricate(:user) }

Fabricate(:login_test_user)
Fabricate(:admin_test_user)
Fabricate(:user_matt)
Fabricate(:user_jeff)
Fabricate(:user_chad)