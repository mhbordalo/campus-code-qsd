require 'rails_helper'

describe 'periodicity API' do
  context 'GET api/v1/periodicities' do
    it 'list all periodicities' do
      create(:periodicity, name: 'Mensal', deadline: 1)
      create(:periodicity, name: 'Trimestral', deadline: 3)
      create(:periodicity, name: 'Anual', deadline: 12)

      get '/api/v1/periodicities'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 3
      expect(json_response[0]['id']).to eq(1)
      expect(json_response[1]['id']).to eq(2)
      expect(json_response[2]['id']).to eq(3)
      expect(json_response[0]['name']).to eq('Mensal')
      expect(json_response[1]['name']).to eq('Trimestral')
      expect(json_response[2]['name']).to eq('Anual')
      expect(json_response[0]['deadline']).to eq(1)
      expect(json_response[1]['deadline']).to eq(3)
      expect(json_response[2]['deadline']).to eq(12)
    end

    it 'return empty if there is no periodicities' do
      get '/api/v1/periodicities'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response).to eq []
    end

    it 'Falha simulada por erro interno no nosso servidor' do
      create(:periodicity, name: 'Mensal', deadline: 1)
      create(:periodicity, name: 'Trimestral', deadline: 3)
      create(:periodicity, name: 'Anual', deadline: 12)
      allow(Periodicity).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)

      get '/api/v1/periodicities'

      expect(response.status).to eq 500
    end
  end
end
