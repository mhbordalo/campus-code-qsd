FactoryBot.define do
  factory :promotion do
    code { 'MyString' }
    name { 'MyString' }
    user_create { 1 }
    user_aprove { nil }
    start { DateTime.now }
    finish { 10.days.from_now }
    discount { 1 }
    maximum_discount_value { '9.99' }
    coupon_quantity { 1 }
    status { 0 }
    approve_date { '2023-02-15' }
    approval_date { '2023-02-15' }
    products { ['Product 1', 'Product 2'] }
  end
end
