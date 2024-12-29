require 'rails_helper'

describe 'Vendedor visualiza detalhes de um pedido' do
  it 'pendente com sucesso' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    create(:order, price: 100, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    order = create(:order, price: 150, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    fake_response_customer = double(api_result_customer)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)

    login_as(salesman)
    visit(orders_path)
    click_on order.order_code

    expect(page).to have_content "Detalhes do Pedido - #{order.order_code}"
    expect(page).to have_field 'salesman', disabled: true, with: "#{salesman.name} (#{salesman.email})"
    expect(page).to have_css '#status', text: 'Pendente'
    expect(page).to have_field 'customer_identification', disabled: true, with: '875.914.387-86'
    expect(page).to have_field 'customer_name', disabled: true, with: 'José da Silva'
    expect(page).to have_field 'price', disabled: true, with: 'R$ 150,00'
    expect(page).not_to have_field 'cancel_reason', disabled: true
  end

  it 'pago com sucesso' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    create(:order, status: 3, price: 20.50, discount: 2.0, customer_doc_ident: '87591438786',
                   payment_mode: 'Cartão de Crédito', paid_at: 2.days.ago, salesman_id: salesman.id)
    order = create(:order, status: 3, price: 43.50, discount: 3.0, customer_doc_ident: '87591438786',
                           payment_mode: 'Cartão de Crédito', paid_at: 3.days.ago, salesman_id: salesman.id)
    fake_response_customer = double(api_result_customer)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)

    login_as(salesman)
    visit(orders_path)
    click_on order.order_code

    expect(page).to have_content "Detalhes do Pedido - #{order.order_code}"
    expect(page).to have_field 'salesman', disabled: true, with: "#{salesman.name} (#{salesman.email})"
    expect(page).to have_css '#status', text: 'Pago'
    expect(page).to have_field 'paid_at', disabled: true, with: I18n.l(3.days.ago, format: :date_time)
    expect(page).to have_field 'customer_identification', disabled: true, with: '875.914.387-86'
    expect(page).to have_field 'customer_name', disabled: true, with: 'José da Silva'
    expect(page).to have_field 'price', disabled: true, with: 'R$ 43,50'
    expect(page).to have_field 'discount', disabled: true, with: 'R$ 3,00'
    expect(page).to have_field 'price_after_discount', disabled: true, with: 'R$ 40,50'
    expect(page).not_to have_field 'cancel_reason', disabled: true
  end

  it 'cancelado com sucesso' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    create(:order, status: 5, price: 14.50, discount: 0.0, customer_doc_ident: '87591438786',
                   cancel_reason: 'Cliente comprou produto incorreto', salesman_id: salesman.id)
    order = create(:order, status: 5, price: 39.50, discount: 0.0, customer_doc_ident: '87591438786',
                           cancel_reason: 'Cliente desistiu da compra', salesman_id: salesman.id)
    fake_response_customer = double(api_result_customer)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)

    login_as(salesman)
    visit(orders_path)
    click_on order.order_code

    expect(page).to have_content "Detalhes do Pedido - #{order.order_code}"
    expect(page).to have_field 'salesman', disabled: true, with: "#{salesman.name} (#{salesman.email})"
    expect(page).to have_css '#status', text: 'Cancelado'
    expect(page).to have_field 'customer_identification', disabled: true, with: '875.914.387-86'
    expect(page).to have_field 'customer_name', disabled: true, with: 'José da Silva'
    expect(page).to have_field 'price', disabled: true, with: 'R$ 39,50'
    expect(page).to have_field 'discount', disabled: true, with: 'R$ 0,00'
    expect(page).to have_field 'price_after_discount', disabled: true, with: 'R$ 39,50'
    expect(page).to have_field 'cancel_reason', disabled: true, with: 'Cliente desistiu da compra'
  end

  it 'sem conseguir os dados do cliente por não encontrá-lo no sistema de clientes' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    create(:order, price: 150, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    order = create(:order, price: 450, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    fake_response_customer = double(api_result_customer_not_found)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)

    login_as(salesman)
    visit(orders_path)
    click_on order.order_code

    within('div#notice') do
      expect(page).to have_content 'Cliente não encontrado'
    end
    expect(page).to have_content "Detalhes do Pedido - #{order.order_code}"
    expect(page).to have_field 'salesman', disabled: true, with: "#{salesman.name} (#{salesman.email})"
    expect(page).to have_css '#status', text: 'Pendente'
    expect(page).to have_field 'customer_identification', disabled: true, with: '875.914.387-86'
    expect(page).to have_field 'customer_name', disabled: true, with: ''
    expect(page).to have_field 'price', disabled: true, with: 'R$ 450,00'
  end

  it 'sem conseguir os dados do cliente por falha na API' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    create(:order, price: 100, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    order = create(:order, price: 500, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    fake_response_customer = double(api_result_failed)
    allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)

    login_as(salesman)
    visit(orders_path)
    click_on order.order_code

    within('div#alert') do
      expect(page).to have_content 'Não foi possível acessar a API de clientes'
    end
    expect(page).to have_content "Detalhes do Pedido - #{order.order_code}"
    expect(page).to have_field 'salesman', disabled: true, with: "#{salesman.name} (#{salesman.email})"
    expect(page).to have_css '#status', text: 'Pendente'
    expect(page).to have_field 'customer_identification', disabled: true, with: '875.914.387-86'
    expect(page).to have_field 'customer_name', disabled: true, with: ''
    expect(page).to have_field 'price', disabled: true, with: 'R$ 500,00'
  end
end
