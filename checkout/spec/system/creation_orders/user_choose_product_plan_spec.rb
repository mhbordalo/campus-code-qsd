require 'rails_helper'

describe 'Vendedor navega até a escolha do plano' do
  it 'com sucesso' do
    salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
    login_as(salesman)
    fake_response_customer = double(api_result_customer)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)
    fake_response_products = double(api_result_products)
    allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
    fake_response_plans = double(api_result_plans)
    allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)

    visit root_path
    click_on 'Pedidos'
    click_on 'Criar Pedido'
    fill_in 'CPF (ou CNPJ)', with: '87591438786'
    click_on 'Pesquisar Cliente'
    click_on 'Continuar'
    choose 'Hospedagem de Sites'
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Planos'
    end
    expect(page).to have_content 'Hospedagem de Sites'
    expect(page).to have_content 'Hospedagem GO'
    expect(page).to have_content 'Hospedagem I'
    expect(page).to have_content 'Hospedagem II'
  end

  it 'e escolhe um produto com sucesso' do
    salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
    login_as(salesman)
    fake_response_customer = double(api_result_customer)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)
    fake_response_products = double(api_result_products)
    allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
    fake_response_plans = double(api_result_plans)
    allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)
    fake_response_prices = double(api_result_prices)
    allow(Faraday).to receive(:get).with(url_api_product_prices('3')).and_return(fake_response_prices)

    visit root_path
    click_on 'Pedidos'
    click_on 'Criar Pedido'
    fill_in 'CPF (ou CNPJ)', with: '87591438786'
    click_on 'Pesquisar Cliente'
    click_on 'Continuar'
    choose 'Hospedagem de Sites'
    click_on 'Continuar'
    choose 'Hospedagem II'
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Preços'
    end
    expect(page).to have_content 'Hospedagem de Sites / Hospedagem II'
    expect(page).to have_content 'Trimestral'
    expect(page).to have_content 'Semestral'
  end

  it 'e retorna à página anterior sem perdas de informação' do
    salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
    login_as(salesman)
    mocked_answer = double(api_result_customer)
    allow(Faraday).to receive(:get).and_return(mocked_answer)

    visit root_path
    click_on 'Pedidos'
    click_on 'Criar Pedido'
    fill_in 'CPF (ou CNPJ)', with: '87591438786'
    click_on 'Pesquisar Cliente'
    mocked_answer = double(api_result_products)
    allow(Faraday).to receive(:get).and_return(mocked_answer)
    click_on 'Continuar'
    choose 'Hospedagem de Sites'
    mocked_answer = double(api_result_plans)
    allow(Faraday).to receive(:get).and_return(mocked_answer)
    click_on 'Continuar'
    choose 'Hospedagem II'
    mocked_answer = double(api_result_products)
    allow(Faraday).to receive(:get).and_return(mocked_answer)
    click_on 'Voltar'

    expect(page).to have_content 'Produtos'
    expect(find_field('creation_order_product_group_form_1hospedagem_de_sites').checked?).to eq(true)
  end

  it 'e tenta continuar sem escolher um plano' do
    salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
    login_as(salesman)
    fake_response_customer = double(api_result_customer)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)
    fake_response_products = double(api_result_products)
    allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
    fake_response_plans = double(api_result_plans)
    allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)

    visit root_path
    click_on 'Pedidos'
    click_on 'Criar Pedido'
    fill_in 'CPF (ou CNPJ)', with: '87591438786'
    click_on 'Pesquisar Cliente'
    click_on 'Continuar'
    choose 'Hospedagem de Sites'
    click_on 'Continuar'
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Planos'
    end
    expect(page).to have_content 'Deve ser selecionada uma das opções'
  end

  it 'e ocorre um erro na API' do
    salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
    login_as(salesman)
    fake_response_customer = double(api_result_customer)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)
    fake_response_products = double(api_result_products)
    allow(Faraday).to receive(:get).with(url_api_products).and_return(fake_response_products)
    fake_response_plans = double(api_result_failed)
    allow(Faraday).to receive(:get).with(url_api_product_plans('1')).and_return(fake_response_plans)

    visit root_path
    click_on 'Pedidos'
    click_on 'Criar Pedido'
    fill_in 'CPF (ou CNPJ)', with: '87591438786'
    click_on 'Pesquisar Cliente'
    click_on 'Continuar'
    choose 'Hospedagem de Sites'
    click_on 'Continuar'

    expect(page).to have_content 'Hospedagem de Sites'
    expect(page).to have_content 'Não foi possível acessar a API de planos'
  end
end
