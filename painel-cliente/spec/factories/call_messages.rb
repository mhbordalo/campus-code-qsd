FactoryBot.define do
  factory :call_message do
    call { nil }
    user { nil }
    message { 'MyString' }
  end
end
