require 'cpf_cnpj'

class User < ApplicationRecord
  has_many :calls, dependent: :restrict_with_exception
  has_many :products, dependent: :restrict_with_exception
  has_many :call_messages, dependent: :restrict_with_exception
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, :identification, presence: true
  validates :name, :city, :state,
            format: { with: /\A[a-zA-ZÀ-ú]+(\s?[a-zA-ZÀ-ú]+)*\z/m,
                      message: I18n.t('accepts_only_text') }
  validates :identification, numericality: { only_integer: true }
  validates :phone_number, length: { is: 16 }
  validates :zip_code, length: { is: 9 }
  validates :state, length: { is: 2 }
  validates :identification, uniqueness: true
  validate :cpf_cnpj_length, if: -> { identification.present? }
  validate :cpf_valid, if: -> { identification.to_s.length == 11 }
  validate :cnpj_valid, if: -> { identification.to_s.length == 14 }
  enum status: { active: 0, inactive: 5 }
  enum role: { client: 0, administrator: 10 }
  def valid_for_authentication?
    validates_format_of? ? yield : false
  end

  def unauthenticated_message
    :status == 'false' ? super : 'Dominio do email não e valido para administrador !!!!'
  end

  def validates_format_of?
    if administrator?
      domain = email.split('@').pop
      domain == 'locaweb.com.br'
    else
      true
    end
  end

  def active_for_authentication?
    active?
  end

  def inactive_message
    :status == 'active' ? super : :account_inactive
  end

  private

  def cpf_valid
    CPF.valid?(identification.to_i) ? '' : errors.add('identification')
  end

  def cnpj_valid
    CNPJ.valid?(identification.to_i) ? '' : errors.add('identification')
  end

  def cpf_cnpj_length
    return if identification.to_s.length == 11 || identification.to_s.length == 14

    errors.add(:identification, 'CPF/CNPJ deve ter 11 ou 14 caracteres')
  end
end
