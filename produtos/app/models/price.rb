class Price < ApplicationRecord
  belongs_to :periodicity
  belongs_to :plan
  enum status: { active: 1, inactive: 0 }
  validates :price, :status, presence: true
  validates :price, numericality: { greater_than: 0 }
end
