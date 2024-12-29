class Checkout
  attr_accessor :creditcard_token, :client_cpf, :order, :final_value, :installment

  def initialize(creditcard_token:, client_cpf:, order:, final_value:, installment:)
    @creditcard_token = creditcard_token
    @client_cpf = client_cpf
    @order = order
    @final_value = final_value
    @installment = installment
  end

  def self.send(checkout)
    parametro = { charge: { creditcard_token: checkout.creditcard_token,
                            client_cpf: checkout.client_cpf,
                            order: checkout.order,
                            final_value: checkout.final_value } }

    url = "#{ENV.fetch('BASE_URL_CHARGES')}/charges"
    headers = { 'Content-Type': 'application/json' }
    Faraday.post(url, parametro.to_json, headers)
  end

  def self.inform_checkout(order)
    Faraday.post("#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{order}/awaiting_payment")
  end
end
