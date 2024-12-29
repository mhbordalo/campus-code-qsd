require 'rails_helper'

RSpec.describe ProductService do
  describe '#list_products' do
    context 'Product Group' do
      it 'list with product group' do
        json_response = [{ id: 123, name: 'Hospedagem GO',
                           description: '1 Site' }]
        mocked_answer = double({ status: 200,
                                 body: JSON.generate(json_response) })
        url = "#{Rails.configuration.external_apis['products_api_url']}/product_groups"
        allow(Faraday).to receive(:get).with(url).and_return(mocked_answer)

        produtos_listados = ProductService.list_product_group
        expect(produtos_listados).to eq({ status: 'SUCCESS',
                                          data: [{ id: 123,
                                                   name: 'Hospedagem GO',
                                                   description: '1 Site' }],
                                          status_message: 'OK' })
      end

      it 'empty product group list' do
        url = "#{Rails.configuration.external_apis['products_api_url']}/product_groups"
        allow(Faraday).to receive(:get).with(url).and_return(double({ status: 200, body: '[]' }))

        produtos_listados = ProductService.list_product_group

        expect(produtos_listados).to eq({ status: 'SUCCESS', status_message: 'OK', data: [] })
      end

      it 'fail to access API' do
        url = "#{Rails.configuration.external_apis['products_api_url']}/product_groups"
        allow(Faraday).to receive(:get).with(url).and_return(double({ status: 500 }))

        produtos_listados = ProductService.list_product_group

        expect(produtos_listados).to eq({ status: 'ERROR_API',
                                          data: {},
                                          status_message: 'Não foi possível acessar a API de grupos de produto' })
      end

      it 'return error from raised exceptions' do
        url = "#{Rails.configuration.external_apis['products_api_url']}/product_groups"
        allow(Faraday).to receive(:get).with(url).and_raise(Faraday::TimeoutError)

        produtos_listados = ProductService.list_product_group

        expect(produtos_listados).to eq({ status: 'ERROR_API', data: {}, status_message: 'timeout' })
      end
    end
    context 'Plan List' do
      it 'list with plans' do
        json_response = [{ id: 123, name: 'Email Locaweb Básico',
                           description: '2 caixas de email',
                           details: '2 caixas de email ilimitadas' }]
        mocked_answer = double({ status: 200,
                                 body: JSON.generate(json_response) })

        url = "#{Rails.configuration.external_apis['products_api_url']}/product_groups/2/plans"
        allow(Faraday).to receive(:get).with(url).and_return(mocked_answer)

        planos_listados = ProductService.list_plans(2)
        expect(planos_listados).to eq({ status: 'SUCCESS',
                                        data: [{ id: 123,
                                                 name: 'Email Locaweb Básico',
                                                 description: '2 caixas de email',
                                                 details: '2 caixas de email ilimitadas' }],
                                        status_message: 'OK' })
      end

      it 'list with prices' do
        json_response = [{
          id: 25,
          price: 80.97,
          plan: {
            id: 3,
            name: 'Hospedagem II',
            description: 'Sites ilimitados, 50 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
            product_group_id: 1,
            status: 'active',
            details: '5 usuários FTP, Armazenamento e Transferencia ilimitada'
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
            code: 'HOST',
            status: 'active'
          }
        }]
        mocked_answer = double({ status: 200,
                                 body: JSON.generate(json_response) })
        url = "#{Rails.configuration.external_apis['products_api_url']}/plans/2/prices"
        allow(Faraday).to receive(:get).with(url).and_return(mocked_answer)

        planos_listados = ProductService.list_prices(2)
        expect(planos_listados).to eq({ status: 'SUCCESS',
                                        data: [{ id: 25,
                                                 price: 80.97,
                                                 plan: 'Hospedagem II',
                                                 periodicity: 'Trimestral' }],
                                        status_message: 'OK' })
      end
    end
  end
end
