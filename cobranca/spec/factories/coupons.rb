FactoryBot.define do
  factory :coupon do
    code { 'MyString' }
    promotion { nil }
    status { 1 }
    consumption_date { '2023-02-15' }
    consumption_application { 'MyString' }
  end
end
