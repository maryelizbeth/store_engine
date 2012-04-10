Fabricator(:product_category, :class_name => "ProductCategory") do 
   name        { Faker::Lorem.words(2).each(&:capitalize!).join(" ") }
end