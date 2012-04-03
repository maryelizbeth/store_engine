Fabricator(:user, :class_name => "User") do 
   full_name      { Faker::Name.name }
   email_address  { Faker::Internet.email }
   display_name   { Faker::Internet.user_name }
end 