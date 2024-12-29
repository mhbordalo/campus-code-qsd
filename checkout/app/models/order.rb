require 'securerandom'
require 'cpf_cnpj'

class Order < ApplicationRecord
  belongs_to :salesman, class_name: 'User'
  has_one :paid_commission, dependent: :destroy

  scope :pending_or_awaiting, -> { where(status: :pending).or(where(status: :awaiting_payment)) }

  enum status: { pending: 0, awaiting_payment: 2, paid: 3, cancelled: 5 }

  before_validation :gen_order_code, on: :create

  validates :order_code,
            :price,
            :product_group_id,
            :product_group_name,
            :product_plan_id,
            :product_plan_name,
            :product_plan_periodicity_id,
            :product_plan_periodicity,
            :status,
            :customer_doc_ident,
            presence: true

  validates :cancel_reason, if: :cancelled?, presence: true
  validates :discount, if: :price, numericality: { less_than_or_equal_to: :price }

  paginates_per 8

  def renew_order
    new_order_data = attributes.symbolize_keys.except(:created_at, :updated_at, :status, :order_code, :price,
                                                      :discount, :id, :cancel_reason, :paid_at)

    new_order_data[:price] = get_updated_price(product_plan_id)

    Order.create!(new_order_data)
  end

  def customer_doc_ident_formatted
    case customer_doc_ident.size
    when 11
      cpf = CPF.new(customer_doc_ident)
      cpf.formatted
    when 14
      cnpj = CNPJ.new(customer_doc_ident)
      cnpj.formatted
    end
  end

  def price_after_discount
    price - discount
  end

  private

  def get_updated_price(product_plan_id)
    product_service = ProductService.list_prices(product_plan_id)

    raise StandardError, product_service[:status_message] unless product_service[:status] == 'SUCCESS'

    renewal_plan_data = product_service[:data].filter { |item| item[:id] == product_plan_periodicity_id }

    raise ArgumentError, 'Plano não está mais ativo.' if renewal_plan_data.empty?

    renewal_plan_data[0][:price]
  end

  def gen_order_code
    self.order_code = SecureRandom.alphanumeric(10).upcase
  end
end
