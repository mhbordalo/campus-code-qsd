require 'rails_helper'

describe 'Grupo de Produtos API' do
  context 'GET api/v1/product_groups' do
    it 'com sucesso' do
      ProductGroup.create!(name: 'Hospedagem de Sites', description: 'Domínio e SSL grátis com sites
       ilimitados e o melhor custo-benefício', code: 'HOST')
      ProductGroup.create!(name: 'E-mail Locaweb', description: 'Tenha um e-mail profissional e passe
       mais credibilidade', code: 'EMAIL')

      get '/api/v1/product_groups'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response[0]['id']).to eq(1)
      expect(json_response[0]['name']).to eq('Hospedagem de Sites')
      expect(json_response[0]['description']).to eq('Domínio e SSL grátis com sites
       ilimitados e o melhor custo-benefício')
      expect(json_response[0]['code']).to eq('HOST')
      expect(json_response[0]['status']).to eq('active')
      expect(json_response[1]['id']).to eq(2)
      expect(json_response[1]['name']).to eq('E-mail Locaweb')
      expect(json_response[1]['description']).to eq('Tenha um e-mail profissional e passe
       mais credibilidade')
      expect(json_response[1]['code']).to eq('EMAIL')
      expect(json_response[1]['status']).to eq('active')
    end

    it 'sem Grupos de Produtos' do
      get '/api/v1/product_groups'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response).to eq([])
    end

    it 'Mostra apenas Gropos de Produtos com status Ativo' do
      ProductGroup.create!(name: 'Hospedagem de Sites', description: 'Domínio e SSL grátis com sites
       ilimitados e o melhor custo-benefício', code: 'HOST')
      ProductGroup.create!(name: 'Hospedagem Cloud', description: 'Servidores de alta performace', code: 'CLOUD')
      ProductGroup.create!(name: 'E-mail Locaweb', description: 'Tenha um e-mail profissional e passe
       mais credibilidade', code: 'EMAIL', status: :inactive)

      get '/api/v1/product_groups'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response[0]['name']).to eq('Hospedagem de Sites')
      expect(json_response[0]['description']).to eq('Domínio e SSL grátis com sites
       ilimitados e o melhor custo-benefício')
      expect(json_response[0]['code']).to eq('HOST')
      expect(json_response[1]['name']).to eq('Hospedagem Cloud')
      expect(json_response[1]['description']).to eq('Servidores de alta performace')
      expect(json_response[1]['code']).to eq('CLOUD')
      expect(json_response.length).to eq(2)
    end

    it 'Falha simulada por erro interno no nosso servidor' do
      ProductGroup.create!(name: 'Hospedagem de Sites', description: 'Domínio e SSL grátis com sites
        ilimitados e o melhor custo-benefício', code: 'HOST')
      ProductGroup.create!(name: 'E-mail Locaweb', description: 'Tenha um e-mail profissional e passe
        mais credibilidade', code: 'EMAIL')
      allow(ProductGroup).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)

      get '/api/v1/product_groups'

      expect(response.status).to eq 500
    end
  end
end
