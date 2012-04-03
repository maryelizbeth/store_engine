Fabricator(:product, :class_name => "Product") do 
   title        { Faker::Lorem.words.join(" ") }
   description  { Faker::Lorem.paragraphs(1) }
   price 1.75
end 