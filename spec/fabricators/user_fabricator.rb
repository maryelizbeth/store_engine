# hungry
pw_digest = "$2a$10$Ot6hhpYJmwC0y2W/2o3.weDQ.XIvbw810sPK2FqzAB8b9k3PL/3JW"
pw_salt   = "BQ9kyhcsbPcz8rWzPqoo"

Fabricator(:user, :class_name => "User") do 
   full_name      { Faker::Name.name }
   email_address  { Faker::Internet.email }
   display_name   { Faker::Internet.user_name }
   crypted_password   pw_digest
   salt               pw_salt
end 

Fabricator(:admin_user, :class_name => "User") do
  full_name      { Faker::Name.name }
  email_address  "admin@lsqa.net"
  display_name   { Faker::Internet.user_name }
  crypted_password   pw_digest
  salt           pw_salt
  is_admin       true
end

Fabricator(:login_test_user, :class_name => "User") do 
   full_name      "John Smith"
   email_address  "john.smith@lsqa.net"
   display_name   "john.smith"
   crypted_password   pw_digest
   salt               pw_salt
end

Fabricator(:full_user, :class_name => "User") do 
   full_name      "Full User"
   email_address  "full.user@lsqa.net"
   display_name   "fuser"
   crypted_password   pw_digest
   salt               pw_salt
end


# Normal user with full name "Matt Yoho", email address "demoXX+matt@jumpstartlab.com", password of "hungry" and no display name
# Normal user with full name "Jeff", email address "demoXX+jeff@jumpstartlab.com", password of "hungry" and display name "j3"
# User with admin priviliges with full name "Chad Fowler", email address "demoXX+chad@jumpstartlab.com", password of "hungry", and display name "SaxPlayer"

Fabricator(:user_matt, :class_name => "User") do 
   full_name      "Matt Yoho"
   email_address  "demo06+matt@jumpstartlab.com"
   crypted_password   pw_digest
   salt               pw_salt
end

Fabricator(:user_jeff, :class_name => "User") do 
   full_name      "Jeff"
   email_address  "demo06+jeff@jumpstartlab.com"
   display_name   "j3"
   crypted_password   pw_digest
   salt               pw_salt
end

Fabricator(:user_chad, :class_name => "User") do 
   full_name      "Chad Fowler"
   email_address  "demo06+chad@jumpstartlab.com"
   display_name   "SaxPlayer"
   crypted_password   pw_digest
   salt               pw_salt
   is_admin           true
end