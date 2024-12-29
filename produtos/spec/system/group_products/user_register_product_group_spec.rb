require 'rails_helper'

describe 'Usuário cadastra um grupo de produto' do
  it 'e não esta logado' do
    visit new_product_group_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end
  it 'a apartir da página de inicial' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')
    create(:product_group, name: 'Hospedagem Pro', description: 'Hospedagem sites', code: 'HPPRO')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end
    click_on 'Cadastrar novo'

    expect(current_path).to eq new_product_group_path
    expect(page).to have_content 'Cadastrar novo Grupo de Produto'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Código'
  end

  it 'com sucesso' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end
    click_on 'Cadastrar novo'
    fill_in 'Nome', with: 'Hospedagem'
    fill_in 'Descrição', with: 'Hospedagem sites'
    fill_in 'Código', with: 'HOSPE'
    click_on 'Salvar'

    product_group = ProductGroup.first
    expect(current_path).to eq product_group_path(product_group)
    expect(page).to have_content 'Grupo de produtos cadastrado com sucesso.'
    expect(page).to have_content 'Hospedagem'
    expect(page).to have_content 'Hospedagem sites'
    expect(page).to have_content 'HOSPE'
    expect(page).to have_content 'Ativo'
  end

  it 'e não preenche campos obrigatórios' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end
    click_on 'Cadastrar novo'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível cadastrar grupo de produtos.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Código não pode ficar em branco'
  end
end
