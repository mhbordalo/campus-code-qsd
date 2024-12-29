require 'rails_helper'
describe 'Client API' do
  context 'GET /api/v1/client/27021991860' do
    it 'com sucesso' do
      create(:user, name: 'Jose da Silva', identification: 27_021_991_860)

      get '/api/v1/clients/27021991860'

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = response.parsed_body
      expect(json_response['name']).to eq('Jose da Silva')
    end

    it 'e não existe o CPF/CNPJ ' do
      create(:user, name: 'Jose da Silva', identification: 27_021_991_860)

      get '/api/v1/clients/96460930007'
      expect(response.status).to eq 404
    end
  end

  context 'POST  /API/V1/clients' do
    it 'com sucesso' do
      post '/api/v1/clients', params: { user:
                                        {
                                          name: 'Clarice Lispector',
                                          email: 'clarice@email.com.br',
                                          identification: 27_021_991_860,
                                          address: 'Av. Tamandaré, 1234',
                                          zip_code: '22755-170',
                                          city: 'São Paulo',
                                          state: 'SP',
                                          phone_number: '(11) 9 9999-3355',
                                          birthdate: '1980-01-01',
                                          corporate_name: 'ClariceLispector Company LTDA'
                                        } }

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = response.parsed_body
      expect(json_response['name']).to eq('Clarice Lispector')
      expect(json_response['email']).to eq('clarice@email.com.br')
      expect(json_response['identification']).to eq 27_021_991_860
      expect(json_response['address']).to eq('Av. Tamandaré, 1234')
      expect(json_response['zip_code']).to eq('22755-170')
      expect(json_response['city']).to eq('São Paulo')
      expect(json_response['state']).to eq('SP')
      expect(json_response['phone_number']).to eq('(11) 9 9999-3355')
      expect(json_response['birthdate']).to eq('1980-01-01')
      expect(json_response['corporate_name']).to eq('ClariceLispector Company LTDA')
    end

    it 'e não envia dados obrigatorios' do
      users_params = { user:
                        {
                          email: 'clarice@email.com.br',
                          identification: 27_021_991_860,
                          address: 'Av. Tamandaré, 1234',
                          zip_code: '22755-170',
                          city: 'São Paulo',
                          state: 'SP',
                          phone_number: '(11) 9 9999-3355',
                          birthdate: '1980-01-01',
                          corporate_name: 'ClariceLispector Company LTDA'
                        } }

      post '/api/v1/clients', params: users_params

      expect(response.status).to eq 400
    end

    it 'Se há um  erro interno' do
      allow(User).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      users_params = { user:
                        {
                          name: 'Clarice Lispector',
                          email: 'clarice@email.com.br',
                          identification: 27_021_991_860,
                          address: 'Av. Tamandaré, 1234',
                          zip_code: '22755-170',
                          city: 'São Paulo',
                          state: 'SP',
                          phone_number: '(11) 9 9999-3355',
                          birthdate: '1980-01-01',
                          corporate_name: 'ClariceLispector Company LTDA'
                        } }

      post '/api/v1/clients', params: users_params

      expect(response.status).to eq 500
    end
  end
end
