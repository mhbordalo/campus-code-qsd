class ProductGroup < ApplicationRecord
  has_one_attached :icon
  has_many :plans, dependent: :nullify
  has_many :prices, through: :plans
  has_many :servers, dependent: :nullify
  validates :name, :description, :code, :status, presence: true
  validates :code, length: { maximum: 5 }
  validates :code, uniqueness: true
  enum status: { active: 5, inactive: 0 }

  before_save :uppercase_code
  after_commit :deactivate_plans_and_pricing_for_product_group, on: :update

  private

  def uppercase_code
    code.upcase!
  end

  def deactivate_plans_and_pricing_for_product_group
    return unless status == 'inactive'

    plans.active.update(status: :discontinued)
  end
end
