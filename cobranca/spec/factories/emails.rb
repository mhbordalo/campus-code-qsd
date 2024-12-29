FactoryBot.define do
  sequence :email do |n|
    "user-#{n}@exemplo.com.br"
  end
end
