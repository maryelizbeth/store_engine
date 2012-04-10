Fabricator(:product, :class_name => "Product") do 
   title        { Faker::Lorem.words.each(&:capitalize!).join(" ") }
   description  { Faker::Lorem.paragraphs(1) }
   price        { (rand(99999)+1)/100.0 }
end 