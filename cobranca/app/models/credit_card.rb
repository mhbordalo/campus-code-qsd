class CreditCard < ApplicationRecord
  validates :card_number, :validate_month, :validate_year, :cvv,
            :owner_name, :owner_doc, presence: true
  validates :card_number, length: { is: 16 }
  validates :validate_month, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :validate_year, length: { is: 2 }
  validates :cvv, length: { is: 3 }
  validates :owner_doc, cpf: I18n.t('errors.messages.invalid_CPF')
  validates_associated :credit_card_flag

  validate :check_date_expiration

  encrypts :card_number
  encrypts :validate_month
  encrypts :validate_year
  encrypts :cvv
  encrypts :owner_name
  encrypts :validate_doc

  belongs_to :credit_card_flag

  before_validation :generate_data, on: :create

  def to_json(*_args)
    { token:, owner_name:, alias: self.alias,
      flag_id: credit_card_flag.id, flag_name: credit_card_flag.name }
  end

  private

  def generate_data
    generate_token
    generate_alias
  end

  def generate_token
    self.token = SecureRandom.alphanumeric(20).upcase
  end

  def generate_alias
    self.alias = card_number[12..]
  end

  def check_date_expiration
    if check_valid_month_year
      today = Time.zone.now
      return if Time.zone.local(2000 + validate_year.to_i,
                                validate_month.to_i) >= Time.zone.local(today.year, today.month)
    end

    errors.add(:validate_year, 'Validade inválida')
  end

  def check_valid_month_year
    validate_year.to_i.positive? && validate_month.to_i.positive?
  end
end
