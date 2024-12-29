FactoryBot.define do
  factory :price do
    price { 9.99 }
    status { :active }
    periodicity { create(:periodicity) }
    plan { create(:plan) }
  end
end
