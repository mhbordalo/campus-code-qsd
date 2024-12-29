FactoryBot.define do
  factory :order do
    order_code { 'ABC123' }
    product_plan_name { 'Plano Hospedagem I' }
    product_plan_periodicity { 'Mensal' }
    salesman_id { 2 }
    payment_mode { 'Cartão de Crédito Visa' }
    user_id { nil }
    price { 100 }
    discount { 20 }
    purchase_date { '2023-01-30' }
    status { 0 }
    cancel_reason { nil }
  end
end
