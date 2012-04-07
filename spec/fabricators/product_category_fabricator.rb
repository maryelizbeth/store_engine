Fabricator(:product_category, :class_name => "ProductCategory") do 
   name        { Faker::Lorem.words.join(" ") }
end