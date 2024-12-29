require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders' do
    it 'atualiza status do pedido para cancelado' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman:)
      create(:order, salesman:)

      post "/api/v1/orders/#{order.order_code}/cancel", params: { cancel_reason: 'O cliente desistiu' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['status']).to eq('cancelled')
      expect(json_response['order_code']).to eq(order.order_code)
      expect(json_response['cancel_reason']).to eq('O cliente desistiu')
    end

    it 'falha se o pedido não for encontrado' do
      post '/api/v1/orders/999999/cancel', params: { cancel_reason: 'Cancelando ordem' }

      expect(response.status).to eq 404
    end

    it 'falha se o motivo do cancelamento não for informado' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman:)
      post "/api/v1/orders/#{order.order_code}/cancel", params: { cancel_reason: '' }

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Motivo do cancelamento não informado'
    end

    it 'e existe um erro interno' do
      allow(Order).to receive(:find_by).and_raise(ActiveRecord::QueryCanceled)

      post '/api/v1/orders/9qeZ77Gih8/cancel', params: { cancel_reason: 'O cliente desistiu' }

      expect(response).to have_http_status(500)
    end
  end
end
