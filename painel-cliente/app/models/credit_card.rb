class CreditCard < ApplicationRecord
  belongs_to :user

  def credit_card_name
    "[#{credit_card_flag}] **** **** **** #{card_number}"
  end

  enum credit_card_flags: { Visa: 1, 'American Express': 2, Mastercard: 3 }
end
