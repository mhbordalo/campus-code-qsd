FactoryBot.define do
  sequence :email do |n|
    "user-#{n}@locaweb.com.br"
  end
end
