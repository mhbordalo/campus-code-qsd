require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders' do
    it 'atualiza status para Pgto a confirmar' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman:)
      create(:order, salesman:)

      post "/api/v1/orders/#{order.order_code}/awaiting_payment"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['status']).to eq('awaiting_payment')
      expect(json_response['order_code']).to eq(order.order_code)
    end

    it 'falha se o pedido não for encontrado' do
      post '/api/v1/orders/999999/awaiting_payment'

      expect(response.status).to eq 404
    end
  end
end
