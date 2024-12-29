require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders' do
    it 'successo' do
      salesman = create(:user, email: 'user@locaweb.com.br', name: 'Pedro Santos', password: '12345678', admin: false)
      order = create(:order, salesman_id: salesman.id, customer_doc_ident: '22200022201',
                             product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                             product_plan_id: 1, product_plan_name: 'Hospedagem GO',
                             price: 300.00)
      create(:order, salesman_id: salesman.id, customer_doc_ident: '22200022201',
                     product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                     product_plan_id: 1, product_plan_name: 'Hospedagem Premium',
                     price: 250.00, status: :awaiting_payment)

      get "/api/v1/customers/#{order.customer_doc_ident}/orders"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 2
      expect(json_response[0]['product_plan_name']).to eq 'Hospedagem GO'
      expect(json_response[0]['salesman']['name']).to eq 'Pedro Santos'
      expect(json_response[0]['salesman']['email']).to eq salesman.email
    end

    it 'falha se não houver pedidos' do
      get '/api/v1/customers/999999999/orders'

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Nenhum registro encontrado'
    end

    it 'e existe um erro interno' do
      allow(Order).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/customers/22200022201/orders'

      expect(response).to have_http_status(500)
    end
  end
end
