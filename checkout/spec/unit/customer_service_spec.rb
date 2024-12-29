require 'rails_helper'

RSpec.describe CustomerService do
  describe '#get_customer' do
    it 'with success' do
      mocked_answer = double({ status: 200,
                               body: JSON.generate({
                                                     doc_ident: '87591438786',
                                                     name: 'José da Silva',
                                                     email: 'jose.silva@email.com.br',
                                                     address: 'Rua das Palmeiras, 100',
                                                     city: 'São Paulo',
                                                     state: 'SP',
                                                     zipcode: '11111-111',
                                                     phone: '11-99999-8888',
                                                     birthdate: '1980-01-01',
                                                     corporate_name: ''
                                                   }) })

      url = "#{Rails.configuration.external_apis['customer_api_url']}/87591438786"
      allow(Faraday).to receive(:get).with(url).and_return(mocked_answer)

      api_customer = CustomerService.get_customer('87591438786')

      expect(api_customer).to eq({ status: 'SUCCESS',
                                   status_message: 'OK',
                                   data: {
                                     doc_ident: '87591438786',
                                     name: 'José da Silva',
                                     email: 'jose.silva@email.com.br',
                                     address: 'Rua das Palmeiras, 100',
                                     city: 'São Paulo',
                                     state: 'SP',
                                     zipcode: '11111-111',
                                     phone: '11-99999-8888',
                                     birthdate: '1980-01-01',
                                     corporate_name: ''
                                   } })
    end

    it 'not found' do
      url = "#{Rails.configuration.external_apis['customer_api_url']}/11122233345"
      allow(Faraday).to receive(:get).with(url).and_return(double({ status: 404, body: '' }))

      api_customer = CustomerService.get_customer('11122233345')

      expect(api_customer).to eq({ status: 'NOT_FOUND', data: {}, status_message: 'Cliente não encontrado' })
    end

    it 'fail to access API' do
      url = "#{Rails.configuration.external_apis['customer_api_url']}/11122233345"
      allow(Faraday).to receive(:get).with(url).and_return(double({ status: 500 }))

      api_customer = CustomerService.get_customer('11122233345')
      expect(api_customer).to eq({ status: 'ERROR_API',
                                   data: {},
                                   status_message: 'Não foi possível acessar a API de clientes' })
    end

    it 'return error from raised exceptions' do
      url = "#{Rails.configuration.external_apis['customer_api_url']}/11122233345"
      allow(Faraday).to receive(:get).with(url).and_raise(Faraday::TimeoutError)

      api_customer = CustomerService.get_customer('11122233345')

      expect(api_customer).to eq({ status: 'ERROR_API', data: {}, status_message: 'timeout' })
    end
  end

  context('Posts customer to external API') do
    it('with success') do
      response_json = { id: '1232231', doc_ident: '11122233345', name: 'Alberto Santos',
                        email: 'asantos@email.com.br', address: 'Av Central, 2000 apto 201',
                        city: 'Rio de Janeiro', state: 'RJ',
                        zipcode: '20200-021', phone: '21 99999-8888',
                        birthdate: '01/01/2000', corporate_name: '' }

      customer_data = { doc_ident: '11122233345', name: 'Alberto Santos',
                        email: 'asantos@email.com.br', address: 'Av Central, 2000 apto 201',
                        city: 'Rio de Janeiro', state: 'RJ',
                        zipcode: '20200-021', phone: '21 99999-8888',
                        birthdate: '01/01/2000', corporate_name: '' }

      url = Rails.configuration.external_apis['customer_api_url']
      allow(Faraday).to receive(:post).with(url, customer_data.to_json,
                                            { 'Content-Type' => 'application/json' })
                                      .and_return(double({ status: 201, body: JSON.generate(response_json) }))

      api_customer = CustomerService.save_customer(customer_data)

      expect(api_customer).to eq({ status: 'SUCCESS',
                                   data: response_json,
                                   status_message: 'OK' })
    end
  end
end
