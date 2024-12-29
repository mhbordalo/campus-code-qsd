class Product < ApplicationRecord
  belongs_to :user
  has_many :calls, dependent: :restrict_with_exception

  enum status: { active: 0, canceled: 5, waiting_payment: 10 }
  enum installation: { uninstalled: 0, installed: 5 }

  def product_plan_name_plus_order_code
    "#{product_plan_name} - #{order_code}"
  end
end
