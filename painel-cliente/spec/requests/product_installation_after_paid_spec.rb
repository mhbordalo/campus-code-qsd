require 'rails_helper'

describe 'Solicitação de instalação do produto após pagamento' do
  it 'realizada com sucesso' do
    user = create(:user, identification: 23_318_591_084, role: :client)
    product = create(:product, user:, order_code: 'ABC123', status: :waiting_payment, product_plan_name: 'Plano 1')

    response = double('faraday_respose', status: 200, body: {})
    allow(Faraday).to receive(:post).with(
      "#{ENV.fetch('BASE_URL_PRODUCTS')}/install",
      { customer_document: 23_318_591_084, order_code: 'ABC123', plan_name: 'Plano 1' },
      { 'Content-Type' => 'application/json' }
    ).and_return(response)

    login_as user

    url = "#{ENV.fetch('BASE_URL_PRODUCTS')}/install"
    body = { customer_document: 23_318_591_084,
             order_code: product.order_code,
             plan_name: product.product_plan_name }
    headers = { 'Content-Type' => 'application/json' }
    Faraday.post(url, body, headers)

    expect(response.status).to eq 200
  end

  it 'retorna erro 404' do
    user = create(:user, identification: 23_318_591_084, role: :client)
    product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')
    create(:product, user:, order_code: 'ABC456', product_plan_name: 'Plano 2')
    create(:product, user:, order_code: 'ABC789', product_plan_name: 'Plano 3')
    create(:product, user:, order_code: 'ABC321', product_plan_name: 'Plano 4')

    response = double('faraday_respose', status: 404, body: {})
    allow(Faraday).to receive(:post).with(
      "#{ENV.fetch('BASE_URL_PRODUCTS')}/install",
      { customer_document: 23_318_591_084, order_code: 'ABC123', plan_name: 'Plano 1' },
      { 'Content-Type' => 'application/json' }
    ).and_return(response)

    login_as user

    url = "#{ENV.fetch('BASE_URL_PRODUCTS')}/install"
    body = { customer_document: 23_318_591_084,
             order_code: product.order_code,
             plan_name: product.product_plan_name }
    headers = { 'Content-Type' => 'application/json' }
    Faraday.post(url, body, headers)

    expect(response.status).to eq 404
  end
end
