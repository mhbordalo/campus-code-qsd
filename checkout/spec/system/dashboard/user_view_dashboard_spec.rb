require 'rails_helper'

describe 'Vendedor visualiza dashboard' do
  it 'somente com seus pedidos' do
    salesman = create(:user, email: 'salesman@locaweb.com.br', password: '12345678', admin: false)
    salesman2 = create(:user, email: 'salesman2@locaweb.com.br', password: '12345678', admin: false)
    create(:order, price: 10, discount: 2, customer_doc_ident: '87591438786', salesman_id: salesman.id)
    create(:order, price: 50, discount: 2, customer_doc_ident: '87591438786', salesman_id: salesman2.id)

    login_as(salesman)
    visit root_path

    within('div#dashboard') do
      expect(page).not_to have_content 'Filtro'
      expect(page).to have_content 'Vendas pagas no mês (R$ 0,00)'
      expect(page).to have_content 'Pedidos no dia (1)'
      expect(page).to have_content 'Pedidos no mês (1)'
      expect(page).to have_content 'Produtos no mês (1)'
      expect(page).to have_content 'Periodicidades no mês (1)'
    end
  end
end
