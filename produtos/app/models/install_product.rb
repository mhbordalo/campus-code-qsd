class InstallProduct < ApplicationRecord
  enum status: { inactive: 0, active: 1 }
  belongs_to :server

  validates :customer_document, :order_code, presence: true
end
