require 'rails_helper'

describe 'Administrador visualiza dashboard' do
  it 'com todos os pedidos' do
    user_admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    salesman = create(:user, email: 'salesman@locaweb.com.br', password: '12345678', admin: false)
    salesman2 = create(:user, email: 'salesman2@locaweb.com.br', password: '12345678', admin: false)
    create(:order, price: 10, discount: 2, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    create(:order, price: 50, discount: 2, customer_doc_ident: '87591438786', salesman_id: salesman2.id)

    login_as(user_admin)
    visit root_path

    within('div#dashboard') do
      expect(page).to have_content 'Filtro inativo (Todos)'
      expect(page).to have_content 'Vendas pagas no mês (R$ 0,00)'
      expect(page).to have_content 'Pedidos no dia (2)'
      expect(page).to have_content 'Pedidos no mês (2)'
      expect(page).to have_content 'Produtos no mês (2)'
      expect(page).to have_content 'Periodicidades no mês (2)'
    end
  end

  it 'utilizando filtro para visualizar pedidos de um vendedor' do
    user_admin = create(:user, email: 'admin@locaweb.com.br', name: 'Admin', password: '12345678', admin: true)
    salesman = create(:user, email: 'salesman@locaweb.com.br', name: 'Salesman', password: '12345678', admin: false)
    salesman2 = create(:user, email: 'salesman2@locaweb.com.br', name: 'Salesman2', password: '12345678', admin: false)
    create(:order, price: 10, discount: 2, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    create(:order, price: 50, discount: 2, customer_doc_ident: '87591438786', salesman_id: salesman2.id)

    login_as(user_admin)
    visit root_path
    select 'Salesman2', from: 'salesman_id'
    click_on 'Atualizar'

    within('div#dashboard') do
      expect(page).to have_content 'Filtro ativo (Salesman2)'
      expect(page).to have_content 'Vendas pagas no mês (R$ 0,00)'
      expect(page).to have_content 'Pedidos no dia (1)'
      expect(page).to have_content 'Pedidos no mês (1)'
      expect(page).to have_content 'Produtos no mês (1)'
      expect(page).to have_content 'Periodicidades no mês (1)'
    end
  end
end
