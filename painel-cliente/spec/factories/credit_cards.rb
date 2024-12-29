FactoryBot.define do
  factory :credit_card do
    token { 'nh234bvmnk324khkh5k8' }
    card_number { '5378' }
    owner_name { 'José Silveira' }
    credit_card_flag { 'Mastercard' }
    user_id { 1 }
  end
end
