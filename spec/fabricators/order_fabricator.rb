Fabricator(:order, :class_name => "Order") do
  status      :pending
  user_id     { Fabricate(:user).id }
end