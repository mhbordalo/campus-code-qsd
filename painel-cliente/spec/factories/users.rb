FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { '12345678' }
    name { 'Bruce Wayne' }
    identification { 62_429_965_704 }
    city { 'Rio Branco' }
    state { 'SP' }
    phone_number { '(21) 9 8897-5959' }
    zip_code { '22755-170' }
    role { 0 }
  end

  factory :administrator do
    email { generate(:email) }
    password { '12345678' }
    name { 'Alfred Pennyworth' }
    identification { 94_844_031_236 }
    city { 'Rio Branco' }
    state { 'SP' }
    phone_number { '(21) 9 8897-5959' }
    zip_code { '22755-170' }
    role { 10 }
  end
end
