require 'rails_helper'

describe 'Renew Order - Order API' do
  context 'POST /api/v1/orders' do
    it 'Cria um novo pedido a partir de uma ordem existente renovando seu preço de acordo com API externa' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order =  create(:order, status: :paid, product_plan_periodicity_id: 2, product_plan_id: 1, salesman:)

      json_response = [
        {
          id: 1,
          price: '38.97',
          plan: {
            id: 1,
            name: 'Hospedagem GO',
            description: '1 Site, 3 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
            product_group_id: 1,
            details: '1 usuário FTP, Armazenamento e Transferencia ilimitada'
          },
          periodicity: {
            id: 2,
            name: 'Trimestral',
            deadline: 3
          },
          product_group: {
            id: 1,
            name: 'Hospedagem de Sites',
            description: 'Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício',
            code: 'HOST'
          }
        },
        {
          id: 2,
          price: '119.88',
          plan: {
            id: 1,
            name: 'Hospedagem GO',
            description: '1 Site, 3 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
            product_group_id: 1,
            details: '1 usuário FTP, Armazenamento e Transferencia ilimitada'
          },
          periodicity: {
            id: 3,
            name: 'Anual',
            deadline: 12
          },
          product_group: {
            id: 1,
            name: 'Hospedagem de Sites',
            description: 'Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício',
            code: 'HOST'
          }
        }
      ]

      mocked_answer = double({ status: 200,
                               body: JSON.generate(json_response) })

      url = "#{Rails.configuration.external_apis['products_api_url']}/plans/1/prices"

      allow(Faraday).to receive(:get).with(url).and_return(mocked_answer)

      post "/api/v1/orders/#{order.order_code}/renew"

      json_response = response.parsed_body

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['status']).to eq('pending')
      expect(json_response['order_code']).not_to eq(order.order_code)
      expect(json_response['price']).to eq('119.88')
      expect(json_response['salesman']['name']).to eq(salesman.name)
      expect(Order.count).to be(2)
    end

    it 'Falha se plano estiver inativo' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order =  create(:order, status: :paid, product_plan_periodicity_id: 2, product_plan_id: 1, salesman:)

      json_response = []

      mocked_answer = double({ status: 200,
                               body: JSON.generate(json_response) })

      url = "#{Rails.configuration.external_apis['products_api_url']}/plans/1/prices"

      allow(Faraday).to receive(:get).with(url).and_return(mocked_answer)

      post "/api/v1/orders/#{order.order_code}/renew"

      json_response = response.parsed_body

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(json_response['error']).to eq('Plano não está mais ativo.')
      expect(Order.count).to be(1)
    end

    it 'falha se o pedido não for encontrado' do
      post '/api/v1/orders/999999/renew'

      expect(response.status).to eq 404
    end
  end
end
