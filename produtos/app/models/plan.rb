class Plan < ApplicationRecord
  has_many :prices, dependent: :nullify
  has_many :periodicities, through: :prices
  belongs_to :product_group
  validates :name, :description, :details, :status, presence: true
  enum status: { active: 5, discontinued: 0 }

  after_commit :deactivate_prices_for_inactive_plan, on: :update

  private

  def deactivate_prices_for_inactive_plan
    return unless status == 'discontinued'

    prices.active.update(status: :inactive)
  end
end
