class Order
  include Devise::Models
  attr_accessor :id, :price, :discount, :payment_mode, :status, :cancel_reason,
                :salesman_id, :order_code, :product_plan_name, :product_plan_periodicity,
                :customer_doc_ident

  # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
  def initialize(id:, price:, discount:, payment_mode:, status:, cancel_reason:,
                 salesman_id:, order_code:, product_plan_name:, product_plan_periodicity:,
                 customer_doc_ident:)

    @id = id
    @price = price
    @discount = discount
    @payment_mode = payment_mode
    @status = status
    @cancel_reason = cancel_reason
    @salesman_id = salesman_id
    @order_code = order_code
    @product_plan_name = product_plan_name
    @product_plan_periodicity = product_plan_periodicity
    @customer_doc_ident = customer_doc_ident
  end
  # rubocop:enable Metrics/MethodLength, Metrics/ParameterLists

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.where(customer_doc_ident:)
    orders = []
    response = Faraday.get("#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{customer_doc_ident.to_i}/orders")
    if response.status == 200
      data = JSON.parse(response.body)
      data.each_with_index do |d, index|
        orders << Order.new(id: (index + 1).to_i, price: d['price'], discount: d['discount'],
                            payment_mode: d['payment_mode'], cancel_reason: d['cancel_reason'],
                            salesman_id: d['salesman_id'], order_code: d['order_code'],
                            status: d['status'], product_plan_name: d['product_plan_name'],
                            product_plan_periodicity: d['product_plan_periodicity'],
                            customer_doc_ident: d['customer_doc_ident'])
      end
    end
    orders
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def self.find(id:, customer_doc_ident:)
    where(customer_doc_ident:)[id.to_i - 1]
  end

  def self.cancel(order_code)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{order_code}/cancel"
    parametro = { cancel_reason: 'O cliente desistiu da compra' }
    headers = { 'Content-Type': 'application/json' }
    Faraday.post(url, parametro.to_json, headers)
  end

  def self.charger(order_code, customer_doc_ident:)
    orders = []
    where(customer_doc_ident:).each do |order|
      orders << order if order.order_code == order_code && status_valid(order)
    end
    orders
  end

  def self.status_valid(order)
    order.status == 'pending' || order.status == 'awaiting_payment'
  end
end
