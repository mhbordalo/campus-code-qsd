FactoryBot.define do
  factory :order do
    customer_doc_ident { '9999900001' }
    price { rand(100..999.99).round(2) }
    discount { rand(1..99.99).round(2) }
    payment_mode { nil }
    status { 0 }
    cancel_reason { nil }
    product_group_id { 1 }
    product_group_name { 'Hospedagem de Sites' }
    product_plan_id { 1 }
    product_plan_name { 'Hospedagem Go' }
    product_plan_periodicity_id { 1 }
    product_plan_periodicity { 'Mensal' }
    paid_at { nil }
    after :build do |p, options|
      p.product_group_id = options.product_group_id
      p.product_group_name = options.product_group_name
      p.product_plan_id = options.product_plan_id
      p.product_plan_name = options.product_plan_name
      p.product_plan_periodicity_id = options.product_plan_periodicity_id
      p.product_plan_periodicity = options.product_plan_periodicity
    end
  end
end
