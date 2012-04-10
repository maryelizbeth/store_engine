Fabricator(:billing_address, :class_name => "Address") do
  street_1    { Faker::Address.street_address }
  street_2    { Faker::Address.secondary_address }
  city        { Faker::Address.city }
  state       { Faker::Address.us_state_abbr }
  zip_code    { Faker::Address.zip_code }
  address_type        "billing"
end

Fabricator(:shipping_address, :class_name => "Address") do
  street_1    { Faker::Address.street_address }
  street_2    { Faker::Address.secondary_address }
  city        { Faker::Address.city }
  state       { Faker::Address.us_state_abbr }
  zip_code    { Faker::Address.zip_code }
  address_type        "shipping"
end