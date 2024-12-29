require 'rails_helper'

describe 'Usuário vê uma lista de grupos de produtos' do
  it 'e não esta logado' do
    visit product_groups_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'com sucesso' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')
    group = create(:product_group)
    create(:product_group, name: 'Hospedagem Pro', description: 'Hospedagem sites', code: 'HPPRO')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end

    expect(current_path).to eq product_groups_path
    expect(page).not_to have_content 'Não há Grupos de Produtos cadastrados.'
    expect(page).to have_content 'Grupos de Produtos'
    within '#product_group_1' do
      expect(page).to have_content 'Hospedagem'
      expect(page).to have_content group.code
      expect(page).to have_content 'Ativo'
    end

    within '#product_group_2' do
      expect(page).to have_content 'Hospedagem Pro'
      expect(page).to have_content 'HPPRO'
      expect(page).to have_content 'Ativo'
    end
  end

  it 'e não existe grupos de produtos cadastrados' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')

    login_as(user)
    visit root_path
    click_on 'Grupos de Produtos'

    expect(current_path).to eq product_groups_path
    expect(page).to have_content 'Não há Grupos de Produtos cadastrados.'
  end
end
