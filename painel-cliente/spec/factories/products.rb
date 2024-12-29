require 'securerandom'

FactoryBot.define do
  factory :product do
    user { nil }
    price { rand(50..350) }
    purchase_date { '2023-03-02' }
    status { 0 }
    order_code { SecureRandom.alphanumeric(10).upcase }
    salesman { %w[Fred Barney Wilma Betty].sample }
    product_plan_name { %w[Ouro Prata Bronze].sample }
    product_plan_periodicity { %w[Mensal Trimestral Anual].sample }
    discount { rand(0..35) }
    payment_mode { 'Cartão de Crédito' }
    cancel_reason { '' }
    installation_code { SecureRandom.alphanumeric(6).upcase }
    server_code { SecureRandom.alphanumeric(8).upcase }
    installation { 5 }
  end
end
