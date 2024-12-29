require 'rails_helper'

describe 'Order API' do
  context 'POST /api/v1/orders/<order.order_code>/pay' do
    it 'atualiza status do pedido para pago' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman:, status: :awaiting_payment, discount: 10.99)
      create(:order, salesman:)

      post "/api/v1/orders/#{order.order_code}/pay", params: { payment_mode: 'credit_card' }
      json_response = response.parsed_body

      expect(response.status).to eq 200
      expect(PaidCommission.count).to be(1)
      expect(response.content_type).to include 'application/json'
      expect(json_response['status']).to eq('paid')
      expect(json_response['order_code']).to eq(order.order_code)
      expect(json_response['payment_mode']).to eq('credit_card')
      expect(json_response['discount']).to eq('10.99')
      expect(json_response['paid_at']).not_to eq(nil)
    end

    it 'falha se o pedido não for encontrado' do
      post '/api/v1/orders/999999/pay', params: { payment_mode: 'credit_cart' }

      expect(response.status).to eq 404
    end

    it 'falha se não for informado o modo de pagamento' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman:, status: :paid)
      post "/api/v1/orders/#{order.order_code}/pay", params: { payment_mode: '' }

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Modo de pagamento não informado'
    end

    it 'e existe um erro interno' do
      allow(Order).to receive(:find_by).and_raise(ActiveRecord::QueryCanceled)

      post '/api/v1/orders/9qeZ77Gih8/pay', params: { payment_mode: 'credit_card' }

      expect(response).to have_http_status(500)
    end
  end
end
