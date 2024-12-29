require 'rails_helper'

describe 'Order API' do
  context 'POST /api/v1/orders/{order_code}/charge' do
    it 'com sucesso' do
      user = create(:user, identification: 62_429_965_704)
      create(:product, user:, order_code: 'KRR4JOLSRG',
                       product_plan_name: 'Ouro', status: :waiting_payment)

      feedback = double('faraday_respose', status: 200, body: '{}')
      allow(Faraday).to receive(:post).with(
        "#{ENV.fetch('BASE_URL_PRODUCTS')}/install",
        { customer_document: '62429965704', order_code: 'KRR4JOLSRG', plan_name: 'Ouro' }.to_json,
        { 'Content-Type' => 'application/json' }
      ).and_return(feedback)

      login_as user

      body = { charge:
        {
          approve_transaction_number: '123456',
          disapproved_code: '',
          disapproved_reason: '',
          client_doc: '62429965704',
          order_code: 'KRR4JOLSRG'
        } }

      post '/api/v1/order/paid', params: body

      expect(response).to have_http_status(:no_content)
    end

    it 'com falha se os parâmetros não estão completos' do
      user = create(:user, identification: 62_429_965_704)
      create(:product, user:, order_code: 'KRR4JOLSRG',
                       product_plan_name: 'Ouro', status: :waiting_payment)

      feedback = double('faraday_respose', status: 404, body: '{}')
      allow(Faraday).to receive(:post).with(
        "#{ENV.fetch('BASE_URL_PRODUCTS')}/install",
        { customer_document: '62429965704', order_code: 'KRR4JOLSRG', plan_name: 'Ouro' }.to_json,
        { 'Content-Type' => 'application/json' }
      ).and_return(feedback)

      login_as user

      body = { charge:
        {
          approve_transaction_number: '123456',
          disapproved_code: '',
          disapproved_reason: '',
          client_doc: '62429965704',
          order_code: ''
        } }

      post '/api/v1/order/paid', params: body

      expect(response).to have_http_status(:not_found)
    end
  end
end
