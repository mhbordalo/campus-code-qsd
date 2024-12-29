class Charge < ApplicationRecord
  belongs_to :reasons, optional: true
  enum :charge_status, { pending: 1, reproved: 2, aproved: 3 }

  validates :client_cpf, :final_value, :order, :creditcard_token, presence: true
  validate :token_exists

  private

  def token_exists
    return unless CreditCard.find_by(token: creditcard_token).nil?

    errors.add(:creditcard_token, ' não existe este token cadastrado')
  end
end
