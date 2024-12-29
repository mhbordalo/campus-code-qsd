require 'rails_helper'

describe 'Usuario renova um produto' do
  it 'com sucesso' do
    user = create(:user, identification: 23_318_591_084, role: :client)
    create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')

    orders = Rails.root.join('spec/support/json/orders.json').read
    response = double('faraday_respose', status: 200, body: {}.to_json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{JSON.parse(orders)[0]['order_code']}/renew"
    allow(Faraday).to receive(:post).with(url).and_return(response)

    login_as user
    visit products_path
    within('table tbody.active tr:nth-child(1)') do
      click_on 'Renovar'
    end

    expect(page).to have_content 'Lista de produtos'
    expect(page).to have_content 'Ativos'
    expect(response.status).to eq 200
    expect(page).to have_content 'Solicitação de renovação enviada com sucesso'
  end

  it 'e retorna 404 quando nenhum registro foi encontrado' do
    user = create(:user, identification: 23_318_591_084, role: :client)
    create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')

    response = double('faraday_respose', status: 404, body: { response: 'Nenhum registro encontrado' }.to_json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/ABC123/renew"
    allow(Faraday).to receive(:post).with(url).and_return(response)

    login_as user
    visit products_path
    within('table tbody.active tr:nth-child(1)') do
      click_on 'Renovar'
    end

    expect(response.status).to eq 404
    expect(page).to have_content 'Lista de produtos'
    expect(page).to have_content 'Erro ao enviar solicitação de renovação: Nenhum registro encontrado'
  end

  it 'e retorna 400 quando plano não está mais ativo' do
    user = create(:user, identification: 23_318_591_084, role: :client)
    create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')

    response = double('faraday_respose', status: 400, body: { error: 'Plano não está mais ativo.' }.to_json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/ABC123/renew"
    allow(Faraday).to receive(:post).with(url).and_return(response)

    login_as user
    visit products_path
    within('table tbody.active tr:nth-child(1)') do
      click_on 'Renovar'
    end

    expect(response.status).to eq 400
    expect(page).to have_content 'Lista de produtos'
    expect(page).to have_content 'Erro ao enviar solicitação de renovação: Plano não está mais ativo.'
  end
  it 'e retorna 500 quando ocorreu erro inesperado' do
    user = create(:user, identification: 23_318_591_084, role: :client)
    create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')

    response = double('faraday_respose', status: 500, body: { error: 'Ocorreu um erro interno' }.to_json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/ABC123/renew"
    allow(Faraday).to receive(:post).with(url).and_return(response)

    login_as user
    visit products_path
    within('table tbody.active tr:nth-child(1)') do
      click_on 'Renovar'
    end

    expect(response.status).to eq 500
    expect(page).to have_content 'Lista de produtos'
    expect(page).to have_content 'Erro ao enviar solicitação de renovação: Ocorreu um erro interno'
  end
end
