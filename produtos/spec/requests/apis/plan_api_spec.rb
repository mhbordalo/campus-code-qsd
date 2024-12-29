require 'rails_helper'

describe 'plan API' do
  context 'GET api/v1/plan/1' do
    it 'successfully' do
      group = ProductGroup.create!(name: 'Hospedagem de Sites',
                                   description: 'Domínio e SSL grátis',
                                   code: 'HOST')
      plan = Plan.create!(name: 'Hospedagem GO', status: :active,
                          description: '1 Site, 3 Contas de e-mails',
                          product_group: group,
                          details: '1 usuário FTP, Armazenamento e Transferencia ilimitada')

      get "/api/v1/plans/#{plan.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['id']).to eq(1)
      expect(json_response['name']).to eq('Hospedagem GO')
      expect(json_response['description']).to eq('1 Site, 3 Contas de e-mails')
      expect(json_response['product_group_id']).to eq(1)
      expect(json_response['status']).to eq('active')
      expect(json_response['details']).to eq('1 usuário FTP, Armazenamento e Transferencia ilimitada')
    end

    it 'fails' do
      get '/api/v1/plans/9999999'

      expect(response.status).to eq 404
    end

    it 'Falha simulada por erro interno no nosso servidor' do
      group = ProductGroup.create!(name: 'Hospedagem de Sites', description: 'Domínio e SSL grátis', code: 'HOST')
      plan = Plan.create!(name: 'Hospedagem GO', status: :active, description: '1 Site, 3 Contas de e-mails',
                          product_group: group, details: '1 usuário FTP, Armazenamento e Transferencia ilimitada')
      allow(Plan).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/plans/#{plan.id}"

      expect(response.status).to eq 500
    end

    it 'apenas planos ativos' do
      product_group = create(:product_group, name: 'Hospedagem de Sites')

      create(:plan, product_group:, status: :discontinued)
      plan_b = create(:plan, product_group:, status: :active)

      get "/api/v1/product_groups/#{product_group.id}/plans/"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 1
      expect(json_response[0]['name']).to eq plan_b.name
      expect(json_response[0]['description']).to eq plan_b.description
      expect(json_response[0]['details']).to eq plan_b.details
      expect(json_response[0]['status']).to include 'active'
      expect(json_response[0].keys).not_to include('created_at')
      expect(json_response[0].keys).not_to include('updated_at')
    end

    it 'não ha planos ativos' do
      product_group = create(:product_group, name: 'Hospedagem de Sites')

      create(:plan, product_group:, status: :discontinued)
      create(:plan, product_group:, status: :discontinued)

      get "/api/v1/product_groups/#{product_group.id}/plans/"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response).to eq []
    end
  end
end
