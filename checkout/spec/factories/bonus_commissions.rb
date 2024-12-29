FactoryBot.define do
  factory :bonus_commission do
    description { 'MyString' }
    start_date { Date.current }
    end_date { 1.day.from_now }
    commission_perc { '9.99' }
    amount_limit { '9.99' }
    active { false }
  end
end
