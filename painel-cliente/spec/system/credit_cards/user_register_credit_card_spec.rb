require 'rails_helper'

describe 'Usuario faz cadastro de um novo cartão de crédito' do
  it 'redirecionado para a tela de login, se não autenticado' do
    visit orders_path

    expect(current_path).to eq new_user_session_path
  end

  it 've os campos do formulário' do
    user = create(:user, identification: 23_318_591_084, role: :client)

    json_data = Rails.root.join('spec/support/json/orders.json').read
    response = double('faraday_respose', status: 200, body: json_data)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response)

    json_data = Rails.root.join('spec/support/json/order.json').read
    response = double('faraday_respose', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{ENV.fetch('BASE_URL_CHECKOUT')}/1").and_return(response)

    login_as(user, scope: :user)
    visit(orders_path)
    within('table tbody tr:nth-child(1)') do
      click_on 'Pagar'
    end
    click_on('Cadastrar Novo Cartão')

    expect(page).to have_content('Novo cartão de crédito:')
    expect(page).to have_field('Número do cartão')
    expect(page).to have_field('Nome impresso no cartão')
    expect(page).to have_field('Mês de validade')
    expect(page).to have_field('Ano de validade')
    expect(page).to have_field('Código de segurança')
    expect(page).to have_field('Documento')
  end

  it 'com  sucesso' do
    user = create(:user, identification: 23_318_591_084, role: :client)

    json_data = Rails.root.join('spec/support/json/orders.json').read
    response_orders = double('faraday_respose', status: 200, body: json_data)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response_orders)

    json_data_order = Rails.root.join('spec/support/json/order.json').read
    order = JSON.parse(json_data_order)

    response_order = double('faraday_respose', status: 200, body: json_data_order)
    allow(Faraday).to receive(:get).with("#{ENV.fetch('BASE_URL_CHECKOUT')}/1").and_return(response_order)

    creditcard = Rails.root.join('spec/support/json/creditcard.json').read
    response = double('faraday_respose', status: 201, body: creditcard)
    url = "#{ENV.fetch('BASE_URL_CHARGES')}/credit_cards"
    parametro = { card_number: '1234567890123456', validate_month: '12', validate_year: '28',
                  cvv: '123', owner_name: 'vulcano s c silva', owner_doc: '23318591084', credit_card_flag_id: '1' }
    headers = { 'Content-Type': 'application/json' }
    allow(Faraday).to receive(:post).with(url, parametro.to_json, headers).and_return(response)

    login_as(user)
    visit(orders_path)
    within('table tbody tr:nth-child(1)') do
      click_on 'Pagar'
    end
    click_on('Cadastrar Novo Cartão')
    select 'Visa', from: 'Bandeira do cartão'
    fill_in 'Número do cartão', with: '1234567890123456'
    fill_in 'Nome impresso no cartão', with: 'vulcano s c silva'
    fill_in 'Mês de validade', with: 12
    fill_in 'Ano de validade', with: 28
    fill_in 'Código de segurança', with: '123'
    click_on 'Cadastrar'

    expect(response.status).to eq 201
    json_response = JSON.parse(response.body)
    expect(json_response['token']).to eq('12345678901234567890')
    expect(json_response['card_number']).to eq('7890')
    expect(page).to have_content('Cartão Cadastrado com sucesso!!!')

    order_id = order['id']
    order_code = order['order_code']
    expect(page).to have_content('Pagar')
    expect(page).to have_content("Pagamento do Pedido: #{order_code}")
    expect(current_path).to eq checkout_order_path(order_id)
  end

  it 'sem  sucesso, dados invalidos' do
    user = create(:user, identification: 23_318_591_084, role: :client)

    json_data = Rails.root.join('spec/support/json/orders.json').read
    response = double('faraday_respose', status: 200, body: json_data)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response)

    json_data = Rails.root.join('spec/support/json/order.json').read
    response = double('faraday_respose', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("#{ENV.fetch('BASE_URL_CHECKOUT')}/1").and_return(response)
    response = double('faraday_respose', status: 404, body: { message: 'Dados do cartão invalidos !!!' },
                                         content_type: 'application/json')
    url = "#{ENV.fetch('BASE_URL_CHARGES')}/credit_cards"
    parametro = { card_number: '123456', validate_month: '25', validate_year: '2000',
                  cvv: '', owner_name: '', owner_doc: '23318591084', credit_card_flag_id: '1' }

    headers = { 'Content-Type': 'application/json' }
    allow(Faraday).to receive(:post).with(url, parametro.to_json, headers).and_return(response)

    login_as(user)
    visit(orders_path)
    within('table tbody tr:nth-child(1)') do
      click_on 'Pagar'
    end
    click_on('Cadastrar Novo Cartão')
    select 'Visa', from: 'Bandeira do cartão'
    fill_in 'Número do cartão', with: '123456'
    fill_in 'Nome impresso no cartão', with: ''
    fill_in 'Mês de validade', with: 25
    fill_in 'Ano de validade', with: 2000
    fill_in 'Código de segurança', with: ''
    click_on 'Cadastrar'

    expect(response.status).to eq 404
    expect(response.content_type).to include('application/json')
    json_response = JSON.parse(response.body.to_json)
    expect(json_response['message']).to eq('Dados do cartão invalidos !!!')
    expect(page).to have_content('!!! Cartão Invalido !!!')
  end

  it 'desiste do cadastramento de um novo cartoa de credito' do
    user = create(:user, identification: 23_318_591_084, role: :client)

    json_data = Rails.root.join('spec/support/json/orders.json').read
    response_orders = double('faraday_respose', status: 200, body: json_data)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response_orders)

    json_data_order = Rails.root.join('spec/support/json/order.json').read
    order = JSON.parse(json_data_order)
    response_order = double('faraday_respose', status: 200, body: json_data_order)
    allow(Faraday).to receive(:get).with("#{ENV.fetch('BASE_URL_CHECKOUT')}/1").and_return(response_order)

    login_as(user)
    visit(orders_path)
    within('table tbody tr:nth-child(1)') do
      click_on 'Pagar'
    end
    click_on('Cadastrar Novo Cartão')
    fill_in 'Número do cartão', with: '1234567890123456'
    fill_in 'Nome impresso no cartão', with: 'vulcano s c silva'
    fill_in 'Mês de validade', with: 12
    fill_in 'Ano de validade', with: 2028
    fill_in 'Código de segurança', with: '123'
    click_on 'Cancelar'

    order_id = order['id']
    order_code = order['order_code']
    expect(current_path).to eq checkout_order_path(order_id)
    expect(page).to have_content('Pagar')
    expect(page).to have_content("Pagamento do Pedido: #{order_code}")
  end
end
