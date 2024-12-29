class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable, :timeoutable

  has_many :orders, foreign_key: 'salesman_id',
                    class_name: 'Order',
                    dependent: :destroy,
                    inverse_of: :salesman

  has_many :paid_commissions, foreign_key: 'salesman_id',
                              class_name: 'PaidCommission',
                              dependent: :destroy,
                              inverse_of: :salesman

  validates :name, presence: true
  validates :email, presence: true
  validate  :domain_check

  paginates_per 8

  APPROVED_DOMAINS = %w[@locaweb.com.br].freeze

  def domain_check
    return if APPROVED_DOMAINS.any? { |domain| email.end_with?(domain) }

    errors.add(:email, 'não pertence a um domínio válido')
  end

  def active_for_authentication?
    super and active?
  end
end
