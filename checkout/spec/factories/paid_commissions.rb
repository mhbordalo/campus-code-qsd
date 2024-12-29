FactoryBot.define do
  factory :paid_commission do
    paid_at { '2023-02-14 21:48:13' }
    amount { '9.99' }
    bonus_commission { nil }
  end
end
