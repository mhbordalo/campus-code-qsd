require 'rails_helper'

RSpec.describe 'Connecting to Charges API', type: :request do
  describe 'and sending pending order charge request with POST / JSON body ' do
    it 'with success' do
      pending_orders_json = Rails.root.join('spec/support/json/pending_orders.json').read
      pending_orders = JSON.parse(pending_orders_json)

      charge_url = ENV.fetch('BASE_URL_CHARGES')
      charge_response = double('charge_response', status: 200, body: {}.to_json)
      allow(Faraday).to receive(:post).with(charge_url).and_return(charge_response)

      charge_data = Checkout.new(creditcard_token: 'ABC123DE45',
                                 client_cpf: pending_orders[1]['client_doc'],
                                 order: pending_orders[1]['order_code'],
                                 final_value: 100,
                                 installment: 1)

      charge_request = Faraday.post(ENV.fetch('BASE_URL_CHARGES')) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = charge_data.to_json
      end

      expect(charge_request.status).to eq 200
    end

    it 'with failure' do
      pending_orders_json = Rails.root.join('spec/support/json/pending_orders.json').read
      pending_orders = JSON.parse(pending_orders_json)

      charge_url = ENV.fetch('BASE_URL_CHARGES')
      charge_response = double('charge_response', status: 400, body: { error: 'token inválido' }.to_json)
      allow(Faraday).to receive(:post).with(charge_url).and_return(charge_response)

      charge_data = Checkout.new(creditcard_token: 'ABC123DE45',
                                 client_cpf: pending_orders[1]['client_doc'],
                                 order: pending_orders[1]['order_code'],
                                 final_value: 100,
                                 installment: 1)

      charge_request = Faraday.post(ENV.fetch('BASE_URL_CHARGES')) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = charge_data.to_json
      end

      expect(charge_request.status).to eq 400
      expect(charge_request.body).to include('token inválido')
    end
  end
end
