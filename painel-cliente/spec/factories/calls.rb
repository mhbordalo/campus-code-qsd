FactoryBot.define do
  factory :call do
    subject { 'Host com configurado incorretamente' }
    description { 'O host está com nome de domínio errado' }
    status { :open }
    user_id { 1 }
    product_id { 1 }
    call_category_id { 1 }
  end
end
