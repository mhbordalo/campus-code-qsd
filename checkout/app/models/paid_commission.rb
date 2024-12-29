class PaidCommission < ApplicationRecord
  BASE_COMISSION_PERCENTAGE = Rails.configuration.commissions[:base_percentage]

  belongs_to :bonus_commission, optional: true
  belongs_to :salesman, class_name: 'User'
  belongs_to :order

  validates :paid_at, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  scope :after_start_date, ->(start_date) { where('paid_at >= ?', start_date) if start_date.present? }
  scope :before_end_date, ->(end_date) { where('paid_at <=?', end_date + 1.day) if end_date.present? }

  class << self
    def pay_commission_from_order_code(order_code)
      order = Order.find_by({ order_code: })

      raise StandardError, 'Código do pedido não encontrado' if order.nil?

      salesman = order.salesman

      total_order = order.price - order.discount
      current_bonus = current_bonus(order.paid_at)
      comission_amount = calculate_commission(current_bonus, total_order)

      PaidCommission.create!({ paid_at: Time.current, amount: comission_amount,
                               bonus_commission: current_bonus, salesman:, order: })
    end

    def load_all_commissions
      PaidCommission.all
                    .group(:salesman)
                    .sum(:amount)
    end

    def filtered_commissions(query_salesman, start_date, end_date)
      salesmen = User.where('name like ?', "%#{query_salesman}%")
      PaidCommission.where(salesman: salesmen)
                    .after_start_date(start_date)
                    .before_end_date(end_date)
                    .group(:salesman)
                    .sum(:amount)
    end

    private

    def calculate_commission(bonus, total_order)
      commission_perc = bonus.present? ? bonus.commission_perc : BASE_COMISSION_PERCENTAGE
      comission = ((commission_perc / 100.0) * total_order).round(2)
      bonus ? [bonus.amount_limit, comission].min : comission
    end

    def current_bonus(order_date)
      bonuses = BonusCommission.active
                               .where('start_date <= ?', order_date)
                               .where('end_date >= ?', order_date)
                               .order(commission_perc: :desc)
                               .take(1)

      bonuses.count.zero? ? nil : bonuses[0]
    end
  end
end
