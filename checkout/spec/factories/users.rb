FactoryBot.define do
  factory :user do
    name { 'Usuário Teste' }
    email { generate(:email) }
    password { 'abc123' }
    active { true }
  end
end
