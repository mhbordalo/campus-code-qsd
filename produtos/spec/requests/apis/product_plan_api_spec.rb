require 'rails_helper'

describe 'Product Groups and plans API' do
  context 'GET /api/v1/product_groups/1' do
    it 'com sucesso' do
      group = create(:product_group, name: 'Hospedagem de Sites')
      group_b = create(:product_group, name: 'Criador de Sites Novos')

      plan_a = create(:plan, product_group_id: group.id)
      plan_b = create(:plan, product_group_id: group.id)
      create(:plan, product_group_id: group_b.id)

      get "/api/v1/product_groups/#{group.id}/plans/"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 2
      expect(json_response[0]['id']).to eq(1)
      expect(json_response[0]['name']).to eq plan_a.name
      expect(json_response[0]['description']).to eq plan_a.description
      expect(json_response[0]['product_group_id']).to eq(1)
      expect(json_response[0]['status']).to eq('active')
      expect(json_response[0]['details']).to eq plan_a.details
      expect(json_response[0].keys).not_to include('created_at')
      expect(json_response[1]['id']).to eq(2)
      expect(json_response[1]['name']).to eq plan_b.name
      expect(json_response[1]['description']).to eq plan_b.description
      expect(json_response[1]['product_group_id']).to eq(1)
      expect(json_response[1]['status']).to eq('active')
      expect(json_response[1]['details']).to eq plan_b.details
      expect(json_response[1].keys).not_to include('updated_at')
    end

    it 'com product_group not found' do
      get '/api/v1/product_groups/999999/plans/'
      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
    end

    it 'Falha simulada por erro interno no nosso servidor' do
      group = create(:product_group, name: 'Hospedagem de Sites')
      create(:plan, product_group_id: group.id)

      get "/api/v1/product_groups/#{group.id}/plans/"
      allow(ProductGroup).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/product_groups/#{group.id}/plans/"

      expect(response.status).to eq 500
    end

    it 'Falha simulada por erro interno no nosso servidor para product_group not found' do
      allow(ProductGroup).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)

      get '/api/v1/product_groups/999999/plans/'

      expect(response.status).to eq 500
    end
  end
end
