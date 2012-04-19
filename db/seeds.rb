image_base = "http://severe-beach-6680.herokuapp.com/images/image"

index = 0
(1..6).each do |a|
  pc = Fabricate(:product_category)
  a.times do |b| 
    index += 1
    Fabricate(:product, :photo_url => "#{image_base}#{index}.jpg").product_categories << pc
  end
end
(1..3).each { |a| Product.find(a*3).product_categories << ProductCategory.find(a) }
Fabricate(:product, :photo_url => "#{image_base}22.jpg").product_categories << ProductCategory.all

ORDER_STATES = ["pending", "paid", "shipped", "returned", "canceled"]
index = 0
(0..4).each do |a|
  2.times do
    order = Fabricate(:order, :status => ORDER_STATES[a])
    rand(1..3).times do
      if index > 20
        index -= 15
      else
        index += 1
      end
      product = Product.find(index)
      Fabricate(:order_product, :order => order, :product => product, :price => product.price, :quantity => rand(1..5))
    end
  end
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