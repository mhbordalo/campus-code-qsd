class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum :user_type, { regular: 0, admin: 1 }, prefix: true, default: :regular

  APPROVED_DOMAINS = ['locaweb.com.br', 'locaweb.company'].freeze

  validates :email, presence: true, if: :domain_check

  def domain_check
    return if APPROVED_DOMAINS.any? { |word| email.end_with?(word) }

    errors.add(:email, 'não possui um domínio válido.')
  end
end
