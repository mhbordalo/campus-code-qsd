class CreditCardFlag < ApplicationRecord
  enum status: { activated: 0, deactivated: 9 }
  has_one_attached :picture
  validates :name, :rate, :maximum_value, :maximum_number_of_installments,
            :status, presence: true
  validates :rate, :maximum_value, :maximum_number_of_installments,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  before_validation { self.cash_purchase_discount = false if cash_purchase_discount.nil? }
  before_save { self.name = name.upcase }
end
