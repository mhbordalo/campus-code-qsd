class NewCreditCard
  include ActiveModel::Model

  attr_accessor :card_number, :owner_name, :validate_month,
                :validate_year, :cvv, :credit_card_flag_id

  validates :card_number, :validate_year, presence: true
  validates :card_number, length: { is: 16 }
end
