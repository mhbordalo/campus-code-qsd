require 'rails_helper'

describe 'Usuario cancela um pedido' do
  it 'com sucesso' do
    user = create(:user, identification: 23_318_591_084, role: :client)

    json_data = Rails.root.join('spec/support/json/orders.json').read
    response = double('faraday_respose', status: 200, body: json_data)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response)

    orders = Rails.root.join('spec/support/json/orders.json').read
    response = double('faraday_respose', status: 200, body: { message: 'Pedido cancelado com sucesso' }.to_json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{JSON.parse(orders)[0]['order_code']}/cancel"
    parametro = { cancel_reason: 'O cliente desistiu da compra' }
    headers = { 'Content-Type': 'application/json' }
    allow(Faraday).to receive(:post).with(url, parametro.to_json, headers).and_return(response)

    login_as user
    visit orders_path
    within('table tbody tr:nth-child(1)') do
      click_on 'Cancelar'
    end

    expect(page).to have_content 'Lista de Pedidos Pendentes'
    expect(response.status).to eq 200
    expect(page).to have_content 'Pedido cancelado com sucesso'
  end

  it 'e retorna erro 404 quando não é enviado motivo do cancelamento' do
    user = create(:user, identification: 23_318_591_084, role: :client)

    json_data = Rails.root.join('spec/support/json/orders.json').read
    response = double('faraday_respose', status: 200, body: json_data)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response)

    response = double('faraday_respose', status: 404, body: { error: 'Nenhum registro encontrado' }.to_json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/ABC123/cancel"
    parametro = { cancel_reason: 'O cliente desistiu da compra' }
    headers = { 'Content-Type': 'application/json' }
    allow(Faraday).to receive(:post).with(url, parametro.to_json, headers).and_return(response)

    login_as user
    visit orders_path
    within('table tbody tr:nth-child(1)') do
      click_on 'Cancelar'
    end

    expect(page).to have_content 'Lista de Pedidos Pendentes'
    expect(response.status).to eq 404
    expect(page).to have_content 'Nenhum registro encontrado'
  end
end
