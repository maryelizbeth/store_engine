Fabricator(:user, :class_name => "User") do 
   full_name      { Faker::Name.name }
   email_address  { Faker::Internet.email }
   display_name   { Faker::Internet.user_name }
   # password is "test"
   crypted_password "$2a$10$au77qAT/es6PIiTRT/COROcqjulzfliqQDpimlo.H2uzUDNwlpakq"
   salt             "yGTMxkUXyCNMDy1KDs3Y"
   # salt           { "asdasdastr4325234324sdfds" }
   # crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt("secret", salt) }            
end 

Fabricator(:login_test_user, :class_name => "User") do 
   full_name      "John Smith"
   email_address  "john.smith@lsqa.net"
   display_name   "john.smith"
   # password is "test"
   crypted_password "$2a$10$au77qAT/es6PIiTRT/COROcqjulzfliqQDpimlo.H2uzUDNwlpakq"
   salt             "yGTMxkUXyCNMDy1KDs3Y"
   # salt           { "asdasdastr4325234324sdfds" }
   # crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt("secret", salt) }
end 

