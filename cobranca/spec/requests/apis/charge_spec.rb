require 'rails_helper'

describe 'Charge API' do
  context 'POST api/v1/charges' do
    it 'com sucesso' do
      # Arrange
      create(:credit_card_flag)
      credit_card = create(:credit_card)

      charge_params = { charge: { creditcard_token: credit_card.token, client_cpf: '84523412343',
                                  order: 1, final_value: 150.00 } }
      # Act
      post '/api/v1/charges', params: charge_params

      # Assert
      expect(response).to have_http_status(201)
      expect(response.content_type).to include 'application/json'

      json_response = response.parsed_body
      expect(json_response['id']).to eq 1
    end

    it 'com erro' do
      # Arrange
      create(:credit_card_flag)
      credit_card = create(:credit_card)
      charge_params = { charge: { creditcard_token: credit_card.token, client_cpf: '',
                                  order: 1, final_value: 150.00 } }
      # Act
      post '/api/v1/charges', params: charge_params

      # Assert
      expect(response).to have_http_status(:precondition_failed)
      expect(response.content_type).to include 'application/json'

      json_response = response.parsed_body
      expect(json_response['errors']).to include 'CPF do Cliente não pode ficar em branco'
    end

    it 'com erro' do
      # Arrange
      create(:credit_card_flag)
      create(:credit_card)
      charge_params = { charge: { creditcard_token: 'ERROR-ERROR', client_cpf: '84523412343',
                                  order: 1, final_value: 150.00 } }
      # Act
      post '/api/v1/charges', params: charge_params

      # Assert
      expect(response).to have_http_status(:precondition_failed)
      expect(response.content_type).to include 'application/json'

      json_response = response.parsed_body
      expect(json_response['errors']).to include 'Creditcard token  não existe este token cadastrado'
    end
  end

  context 'GET api/v1/charges/1' do
    it 'com sucesso' do
      create(:credit_card_flag)
      credit_card = create(:credit_card)

      charge = Charge.create!(charge_status: :aproved,
                              approve_transaction_number: '2d931510-d99f-494a-8c67-87feb05e1594',
                              reasons_id: 0, creditcard_token: credit_card.token,
                              client_cpf: '798.456.123-00', order: '1002', final_value: 5_500.00)

      get "/api/v1/charges/#{charge.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = response.parsed_body

      expect(json_response['creditcard_token']).to eq credit_card.token
      expect(json_response['client_cpf']).to eq '798.456.123-00'
      expect(json_response['order']).to eq '1002'
      expect(json_response['final_value']).to eq '5500.0'
    end

    it 'inexistente' do
      get '/api/v1/charges/1'

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'

      json_response = response.parsed_body

      expect(json_response['error']).to eq 'Cobrança não encontrada.'
    end

    it 'com erro' do
      get '/api/v1/charges'

      # Assert
      expect(response.status).to eq 405
      expect(response.content_type).to include 'application/json'

      json_response = response.parsed_body
      expect(json_response['error']).to include 'informe um código de cobrança.'
    end
  end
end
