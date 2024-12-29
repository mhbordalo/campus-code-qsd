FactoryBot.define do
  factory :user do
    user_type { 0 }
    email { 'usuario@locaweb.com.br' }
    password { 'abc123' }
  end
end
