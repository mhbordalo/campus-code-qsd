require 'rails_helper'

describe 'Recebe o plano pelo parâmetro da requisição' do
  it 'e envia os preços para as periodicidades disponíveis' do
    group = ProductGroup.create!(name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = Plan.create!(name: 'Hospedagem de Site', product_group: group, status: :active,
                        description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                        details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity_a = Periodicity.create!(name: 'Mensal', deadline: 1)
    periodicity_b = Periodicity.create!(name: 'Trimestral', deadline: 3)
    periodicity_c = Periodicity.create!(name: 'Anual', deadline: 12)
    Price.create!(price: 7.99, plan:, periodicity: periodicity_a, status: :active)
    Price.create!(price: 12.99, plan:, periodicity: periodicity_b, status: :active)
    Price.create!(price: 15.99, plan:, periodicity: periodicity_c, status: :active)
    Price.update(status: :active)

    get "/api/v1/plans/#{plan.id}/prices"

    expect(response.status).to eq 200
    expect(response.content_type).to include 'application/json'
    json_response = response.parsed_body
    expect(json_response.length).to eq(3)
    expect(json_response[0]['id']).to eq(1)
    expect(json_response[0]['price']).to eq('7.99')
    expect(json_response[0]['plan']['id']).to eq(1)
    expect(json_response[0]['plan']['name']).to eq('Hospedagem de Site')
    expect(json_response[0]['plan']['description']).to include('3 Contas de e-mails')
    expect(json_response[0]['plan']['product_group_id']).to eq(1)
    expect(json_response[0]['plan']['details']).to include('Armazenamento ilimitado')
    expect(json_response[0]['periodicity']['id']).to eq(1)
    expect(json_response[0]['periodicity']['name']).to eq('Mensal')
    expect(json_response[0]['periodicity']['deadline']).to eq(1)
    expect(json_response[0]['product_group']['id']).to eq(1)
    expect(json_response[0]['product_group']['name']).to eq('Hospedagem')
    expect(json_response[0]['product_group']['description']).to eq('Hospedagem sites')
    expect(json_response[0]['product_group']['code']).to eq('HPPRO')
    expect(json_response[1]['id']).to eq(2)
    expect(json_response[1]['price']).to eq('12.99')
    expect(json_response[1]['plan']['id']).to eq(1)
    expect(json_response[1]['plan']['name']).to eq('Hospedagem de Site')
    expect(json_response[1]['plan']['description']).to include('3 Contas de e-mails')
    expect(json_response[1]['plan']['product_group_id']).to eq(1)
    expect(json_response[1]['plan']['details']).to include('Armazenamento ilimitado')
    expect(json_response[1]['periodicity']['id']).to eq(2)
    expect(json_response[1]['periodicity']['name']).to eq('Trimestral')
    expect(json_response[1]['periodicity']['deadline']).to eq(3)
    expect(json_response[1]['product_group']['id']).to eq(1)
    expect(json_response[1]['product_group']['name']).to eq('Hospedagem')
    expect(json_response[1]['product_group']['description']).to eq('Hospedagem sites')
    expect(json_response[1]['product_group']['code']).to eq('HPPRO')
    expect(json_response[2]['id']).to eq(3)
    expect(json_response[2]['price']).to eq('15.99')
    expect(json_response[2]['plan']['id']).to eq(1)
    expect(json_response[2]['plan']['name']).to eq('Hospedagem de Site')
    expect(json_response[2]['plan']['description']).to include('3 Contas de e-mails')
    expect(json_response[2]['plan']['product_group_id']).to eq(1)
    expect(json_response[2]['plan']['details']).to include('Armazenamento ilimitado')
    expect(json_response[2]['periodicity']['id']).to eq(3)
    expect(json_response[2]['periodicity']['name']).to eq('Anual')
    expect(json_response[2]['periodicity']['deadline']).to eq(12)
    expect(json_response[2]['product_group']['id']).to eq(1)
    expect(json_response[2]['product_group']['name']).to eq('Hospedagem')
    expect(json_response[2]['product_group']['description']).to eq('Hospedagem sites')
    expect(json_response[2]['product_group']['code']).to eq('HPPRO')
  end

  it 'e somente mostra preços para planos ativos' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :discontinued,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    create(:price, price: 7.99, plan:, periodicity:, status: :active)
    Price.update(status: :active)

    get "/api/v1/plans/#{plan.id}/prices"

    expect(response.status).to eq 404
  end

  it 'e somente mostra preços ativos' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity_a = create(:periodicity, name: 'Mensal', deadline: 1)
    periodicity_b = create(:periodicity, name: 'Trimestral', deadline: 3)
    create(:price, price: 7.99, plan:, periodicity: periodicity_a, status: :active)
    create(:price, price: 12.99, plan:, periodicity: periodicity_b, status: :inactive)
    Price.where(plan:, periodicity: periodicity_a).update(status: :active)

    get "/api/v1/plans/#{plan.id}/prices"

    expect(response.status).to eq 200
    expect(response.content_type).to include 'application/json'
    json_response = response.parsed_body
    expect(json_response.length).to eq(1)
    expect(json_response[0]['id']).to eq(1)
    expect(json_response[0]['price']).to eq('7.99')
    expect(json_response[0]['periodicity']['name']).to eq('Mensal')
  end

  it 'e retorna vazio de não houver preços' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    create(:plan, name: 'Hospedagem de Site', product_group:, status: :active,
                  description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                  details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')

    get '/api/v1/plans/1/prices'

    expect(response.status).to eq 200
    expect(response.content_type).to include 'application/json'
    json_response = response.parsed_body
    expect(json_response).to eq []
  end

  it 'e não encontra' do
    get '/api/v1/plans/999/prices'

    expect(response.status).to eq 404
  end

  it 'Falha simulada por erro interno no nosso servidor' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :discontinued,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    create(:price, price: 7.99, plan:, periodicity:, status: :active)
    allow(Plan).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)

    get "/api/v1/plans/#{plan.id}/prices"

    expect(response.status).to eq 500
  end
end
