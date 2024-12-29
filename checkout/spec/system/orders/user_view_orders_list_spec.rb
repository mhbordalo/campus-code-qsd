require 'rails_helper'

describe 'Orders List View' do
  it 'User should be able to load Orders page' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
    login_as(salesman)
    visit(root_path)
    click_on('Pedidos')

    expect(current_path).to eq(orders_path)
  end

  context 'Salesman view' do
    it 'Seller user view only orders created by him' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      other_user = create(:user, email: 'second-user@locaweb.com.br', password: '12345600', admin: false)
      create_list(:order, 8, customer_doc_ident: '22200022201',
                             salesman_id: salesman.id)
      create_list(:order, 8, customer_doc_ident: '22200022201',
                             salesman_id: other_user.id)

      login_as(salesman)
      visit(orders_path)

      expect(page).to have_css('.order_info', count: 8)
    end
  end

  context 'Admin view' do
    it 'Admin user view all orders' do
      admin = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: true)
      salesman_one = create(:user, email: 'first-user@locaweb.com.br', password: '12345600', admin: false)
      salesman_two = create(:user, email: 'second-user@locaweb.com.br', password: '12345600', admin: false)
      create_list(:order, 8, customer_doc_ident: '22200022201',
                             salesman_id: salesman_one.id)
      create_list(:order, 8, customer_doc_ident: '22200022201',
                             salesman_id: salesman_two.id)

      login_as(admin)
      visit(orders_path)

      expect(page).to have_css('.order_info', count: 8)
    end
  end

  it 'no items in orders list' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)

    login_as(salesman)
    visit(orders_path)

    expect(page).to have_css('.order_info', count: 0)
    expect(page).to have_content('Não foram encontrados pedidos cadastrados associados ao seu login.')
  end
end
