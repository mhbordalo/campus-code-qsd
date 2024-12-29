FactoryBot.define do
  factory :user do
    name { 'Maria' }
    email { generate(:email) }
    password { '123456' }
  end
end
