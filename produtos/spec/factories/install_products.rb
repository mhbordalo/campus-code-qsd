FactoryBot.define do
  factory :install_product do
    customer_document { '000.000.000/00' }
    order_code { 'ABC123' }
    server_id { nil }
  end
end
