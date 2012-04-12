Fabricator(:order, :class_name => "Order") do
  user_id     { Fabricate(:user).id }
end