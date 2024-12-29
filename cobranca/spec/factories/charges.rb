FactoryBot.define do
  factory :charge do
    charge_status { 1 }
    client_cpf { '123.465.798.10' }
    order { '1' }
    final_value { 9_999_999.99 }
    creditcard_token { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9' }
  end
end
