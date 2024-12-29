require 'rails_helper'

describe 'Order API' do
  context 'POST /api/v1/orders/<order.order_code>/discount' do
    it 'atualiza desconto no pedido' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman:, status: :pending, discount: 0)
      create(:order, salesman:)

      post "/api/v1/orders/#{order.order_code}/discount", params: { discount: '20.55' }
      json_response = response.parsed_body

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['status']).to eq('pending')
      expect(json_response['discount']).to eq('20.55')
      expect(json_response['paid_at']).to eq(nil)
    end

    it 'falha se o pedido não for encontrado' do
      post '/api/v1/orders/999999/discount', params: { discount: '20.55' }

      expect(response.status).to eq 404
    end

    it 'falha se não for informado o desconto' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman:, status: :pending, discount: 0)
      post "/api/v1/orders/#{order.order_code}/discount", params: { discount: '' }

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Desconto não informado'
    end

    it 'e existe um erro interno' do
      allow(Order).to receive(:find_by).and_raise(ActiveRecord::QueryCanceled)

      post '/api/v1/orders/9qeZ77Gih8/discount', params: { discount: '10' }

      expect(response).to have_http_status(500)
    end
  end
end
