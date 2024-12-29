class Promotion < ApplicationRecord
  has_many :coupons, dependent: nil
  serialize :products, Array

  enum status: { pending: 0, activated: 9 }

  validates :name, :code, :start, :finish, :discount,
            :maximum_discount_value, :user_create, :coupon_quantity, presence: true
  validates :code, length: { maximum: 15 }
  validates :finish, comparison: { greater_than: :start }
  validates :coupon_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :discount, :maximum_discount_value, numericality: true
  validates :user_create, comparison: { other_than: :user_aprove }

  before_save { self.code = code.upcase }

  def validated?(product)
    activated? && valid_period && product_covered?(product)
  end

  def calculate_discount(price)
    [(discount / 100.0) * price, maximum_discount_value].min
  end

  private

  def valid_period
    Time.current >= start && Time.current <= finish
  end

  def product_covered?(product)
    products.include? product
  end
end
