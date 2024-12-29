require 'rails_helper'

describe 'Usuário vê detalhes de um grupo de produto' do
  it 'e não esta logado' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HOSPE')

    visit product_group_path(product_group)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'e vê informações adicionais' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HOSPE')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end

    link_to_show.click

    expect(current_path).to eq product_group_path(product_group)
    expect(page).to have_content 'Grupo de Produto'
    expect(page).to have_content 'Nome: Hospedagem'
    expect(page).to have_content 'Código: HOSPE'
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_content 'Descrição: Hospedagem sites'
  end

  it 'e voltar para a tela inicial' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')
    create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HOSPE')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end

    link_to_show.click
    click_on 'Início'

    expect(current_path).to eq root_path
  end
end
