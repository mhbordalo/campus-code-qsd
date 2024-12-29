FactoryBot.define do
  factory :credit_card do
    card_number { '1234567890123456' }
    validate_month { 12 }
    validate_year { 99 }
    cvv { 123 }
    owner_name { 'MyString' }
    owner_doc { '71880824485' }
    association :credit_card_flag
  end
end
