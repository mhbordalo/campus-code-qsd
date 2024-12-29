require 'rails_helper'

describe 'Admin vê a lista de vendedores' do
  it 'a partir da página principal' do
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'

    expect(current_path).to eq users_path
    within('div#main') do
      expect(page).to have_content 'Vendedores'
    end
  end

  it 'como resultado da busca' do
    create(:user, name: 'user vendor 1', email: 'uservendor1@locaweb.com.br', password: 'vendor1')
    create(:user, name: 'user vendor 2', email: 'uservendor2@locaweb.com.br', password: 'vendor2')
    create(:user, name: 'user vendor 3', email: 'uservendor3@locaweb.com.br', password: 'vendor3')
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    fill_in 'query', with: '1'
    click_on 'Buscar'

    expect(page).to have_content 'user vendor 1'
    expect(page).to have_content 'uservendor1@locaweb.com.br'
    expect(page).not_to have_content 'user vendor 2'
  end

  it 'vê a mensagem Não existem vendedores cadastrados' do
    user_admin = User.create!(name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    fill_in 'query', with: 'vendedor'
    click_on 'Buscar'

    expect(page).to have_content 'Não foram encontrados vendedores utilizando o critério de busca'
  end
end
