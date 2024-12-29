require 'rails_helper'

describe 'Vendedor navega até a tela de pagamento' do
  it 'com sucesso' do
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
    choose 'Trimestral'
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Cupom'
    end
    expect(page).to have_content 'Cupom de desconto'
  end

  it 'e informa um cupom com sucesso' do
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
    fake_response_validate_coupon = double(api_result_validate_coupon)
    validate_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', price: '80.97', product_plan_name: 'Hospedagem II' }
    allow(Faraday).to receive(:get).with(url_api_payment_validate_coupon, validate_coupon_data)
                                   .and_return(fake_response_validate_coupon)

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
    choose 'Trimestral'
    click_on 'Continuar'
    fill_in 'Cupom de desconto', with: 'BLACKFRIDAY-AS123'
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Confirmação'
    end
    expect(page).to have_content 'Confirmação do Pedido'
    within('tr#order_item') do
      expect(page).to have_content(
        'Hospedagem de Sites Hospedagem II Trimestral R$ 80,97 R$ 2,00 R$ 78,97 BLACKFRIDAY-AS123'
      )
    end
  end

  it 'e retorna à página anterior sem perdas de informação' do
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
    fake_response_validate_coupon = double(api_result_validate_coupon)
    validate_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', price: '80.97', product_plan_name: 'Hospedagem II' }
    allow(Faraday).to receive(:get).with(url_api_payment_validate_coupon, validate_coupon_data)
                                   .and_return(fake_response_validate_coupon)

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
    choose 'Trimestral'
    click_on 'Continuar'
    fill_in 'Cupom de desconto', with: 'BLACKFRIDAY-AS123'
    click_on 'Continuar'
    click_on 'Voltar'

    expect(page).to have_content 'Cupom'
    expect(page).to have_field 'Cupom de desconto', with: 'BLACKFRIDAY-AS123'
  end

  it 'e informa um cupom inválido' do
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
    fake_response_validate_coupon = double(api_result_validate_coupon_invalid)
    validate_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', price: '80.97', product_plan_name: 'Hospedagem II' }
    allow(Faraday).to receive(:get).with(url_api_payment_validate_coupon, validate_coupon_data)
                                   .and_return(fake_response_validate_coupon)

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
    choose 'Trimestral'
    click_on 'Continuar'
    fill_in 'Cupom de desconto', with: 'BLACKFRIDAY-AS123'
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Cupom'
    end
    expect(page).to have_content 'Cupom de desconto inválido para esta compra'
  end

  it 'e informa um cupom inexistente' do
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
    fake_response_validate_coupon = double(api_result_validate_coupon_not_found)
    validate_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', price: '80.97', product_plan_name: 'Hospedagem II' }
    allow(Faraday).to receive(:get).with(url_api_payment_validate_coupon, validate_coupon_data)
                                   .and_return(fake_response_validate_coupon)

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
    choose 'Trimestral'
    click_on 'Continuar'
    fill_in 'Cupom de desconto', with: 'BLACKFRIDAY-AS123'
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Cupom'
    end
    expect(page).to have_content 'Cupom de desconto inexistente'
  end

  it 'e ocorre um erro na API que valida o cupom' do
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
    fake_response_validate_coupon = double(api_result_failed)
    validate_coupon_data = { coupon_code: 'BLACKFRIDAY-AS123', price: '80.97', product_plan_name: 'Hospedagem II' }
    allow(Faraday).to receive(:get).with(url_api_payment_validate_coupon, validate_coupon_data)
                                   .and_return(fake_response_validate_coupon)

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
    choose 'Trimestral'
    click_on 'Continuar'
    fill_in 'Cupom de desconto', with: 'BLACKFRIDAY-AS123'
    click_on 'Continuar'

    within('div#step_active') do
      expect(page).to have_content 'Cupom'
    end
    expect(page).to have_content 'Não foi possível validar este cupom por erro na API'
  end
end
