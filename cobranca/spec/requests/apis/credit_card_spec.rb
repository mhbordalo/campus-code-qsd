require 'rails_helper'

describe 'Credit Card API' do
  context 'POST api/v1/credit_cards' do
    it 'com sucesso' do
      flag = create(:credit_card_flag)
      owner_name = 'José da Silva'
      credit_card_params = { credit_card: { card_number: '1234567890123457', validate_month: 12,
                                            validate_year: 30, cvv: 123, owner_name:,
                                            owner_doc: '71880824485', credit_card_flag_id: flag.id } }
      post '/api/v1/credit_cards', params: credit_card_params

      expect(response).to have_http_status(201)
      expect(response.content_type).to include 'application/json'

      json_response = response.parsed_body
      expect(json_response.length).to eq 5

      expect(json_response).to include 'token', 'alias', 'owner_name', 'flag_name', 'flag_id'

      expect(json_response['token'].length).to eq 20
      expect(json_response['alias']).to eq '3457'
      expect(json_response['owner_name']).to eq owner_name
      expect(json_response['flag_name']).to eq flag.name
      expect(json_response['flag_id']).to eq flag.id
    end
  end

  context 'POST api/v1/credit_cards' do
    it 'Sem sucesso' do
      credit_card_flag = create(:credit_card_flag)
      credit_card_params = { credit_card: { card_number: '1234567890123456', validate_month: 12, validate_year: 30,
                                            cvv: 123, owner_name: 'José da Silva', owner_doc: '12345678996321',
                                            credit_card_flag_id: credit_card_flag.id } }
      post '/api/v1/credit_cards', params: credit_card_params
      expect(response).to have_http_status(412)
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body

      expect(json_response['errors'].length).to eq 1
      expect(json_response['errors'].first).to eq 'CPF do Titular não é um CPF válido'

      expect(json_response).not_to include 'token', 'alias', 'owner_name', 'flag_name', 'flag_id'
    end
  end
end
