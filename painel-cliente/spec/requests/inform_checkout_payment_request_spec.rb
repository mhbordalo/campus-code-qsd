require 'rails_helper'

RSpec.describe 'Connecting to Checkout API', type: :request do
  describe 'and send order code started payment process' do
    it 'with success' do
      awaiting_payment_json = Rails.root.join('spec/support/json/awaiting_payment.json').read
      order_code = JSON.parse(awaiting_payment_json)[0]['order_code'] # N5KDI4HLYH
      inform_url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{order_code}/awaiting_payment"
      inform_response = double('inform_response', status: 200, body: awaiting_payment_json)
      allow(Faraday).to receive(:post).with(inform_url).and_return(inform_response)
      inform_response_parsed_body = JSON.parse(inform_response.body)

      post checkout_order_path(1)

      expect(inform_response.status).to eq 200

      expect(inform_response_parsed_body[0]['status']).to include('awaiting_payment')
      expect(inform_response_parsed_body[0]['order_code']).to include('N5KDI4HLYH')
    end

    it 'with failure - did not find order (error 404)' do
      awaiting_payment_json = Rails.root.join('spec/support/json/awaiting_payment.json').read
      order_code = JSON.parse(awaiting_payment_json)[0]['order_code'] # N5KDI4HLYH
      inform_url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{order_code}/awaiting_payment"
      inform_response = double('inform_response', status: 404, body: { response: 'Nenhum registro encontrado' }.to_json)
      allow(Faraday).to receive(:post).with(inform_url).and_return(inform_response)
      inform_response_parsed_body = JSON.parse(inform_response.body)

      post checkout_order_path(1)

      expect(inform_response.status).to eq 404
      expect(inform_response_parsed_body['response']).to include('Nenhum registro encontrado')
    end

    it 'with failure - did not find order (error 500)' do
      awaiting_payment_json = Rails.root.join('spec/support/json/awaiting_payment.json').read
      order_code = JSON.parse(awaiting_payment_json)[0]['order_code'] # N5KDI4HLYH
      inform_url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{order_code}/awaiting_payment"
      inform_response = double('inform_response', status: 500, body: { error: 'Ocorreu um erro interno' }.to_json)
      allow(Faraday).to receive(:post).with(inform_url).and_return(inform_response)
      inform_response_parsed_body = JSON.parse(inform_response.body)

      post checkout_order_path(1)

      expect(inform_response.status).to eq 500
      expect(inform_response_parsed_body['error']).to include('Ocorreu um erro interno')
    end
  end
end
