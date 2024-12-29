FactoryBot.define do
  factory :credit_card_flag do
    name { 'MyString' }
    rate { 1 }
    maximum_value { 1 }
    maximum_number_of_installments { 1 }
    cash_purchase_discount { false }
    status { 0 }
  end
end
