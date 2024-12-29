class Coupon < ApplicationRecord
  belongs_to :promotion
  enum status: { available: 0, used: 3 }
  scope :coupons_with_order, ->(order_code) { where(order_code:) }

  paginates_per 10

  def self.generate_coupons(quantity, id_promotion)
    coupon = Coupon.new(promotion_id: id_promotion)
    promotion_code = coupon.promotion.code

    quantity.times do
      created_coupon = Coupon.new(promotion_id: id_promotion)
      created_coupon.code = "#{promotion_code}-#{SecureRandom.alphanumeric(5).upcase}"
      created_coupon.status = 0
      created_coupon.save
    end
  end

  def validated?(product)
    available? && promotion.validated?(product)
  end

  def calculate_discount(product, price)
    return 0 unless valid?(product)

    promotion.calculate_discount(price)
  end
end
