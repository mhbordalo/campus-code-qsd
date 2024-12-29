FactoryBot.define do
  factory :product_group do
    name { 'Hospedagem' }
    description { 'Hospedagem sites' }
    code { 'HOS'.to_s + rand(0..99).to_s }
    status { 5 }
  end
end
