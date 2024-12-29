class Periodicity < ApplicationRecord
  has_many :prices, dependent: :nullify
  has_many :plans, through: :prices
  validates :name, :deadline, presence: true
  validates :name, uniqueness: true
  validates :deadline, numericality: { only_integer: true, greater_than: 0 }
end
