require 'rails_helper'

describe 'Usuário edita um grupo de pedido' do
  it 'e não esta logado' do
    product_group = create(:product_group, name: 'Hospedagem Pro', description: 'Hospedagem sites', code: 'HPPRO')

    visit edit_product_group_path(product_group)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'a partir da página de inicial' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')
    product_group = create(:product_group, name: 'Hospedagem Pro', description: 'Hospedagem sites', code: 'HPPRO')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end
    link_to_edit.click

    expect(current_path).to eq edit_product_group_path(product_group)
    expect(page).to have_content 'Editar Grupo de Produto'
    expect(page).to have_field 'Nome', with: 'Hospedagem Pro'
    expect(page).to have_field 'Descrição', with: 'Hospedagem sites'
    expect(page).to have_field 'Código', with: 'HPPRO'
  end

  it 'com sucesso' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')
    product_group = create(:product_group, name: 'Hospedagem Pro', description: 'Hospedagem sites', code: 'HPPRO')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end
    link_to_edit.click
    fill_in 'Nome', with: 'Hospedagem Básica'
    fill_in 'Descrição', with: 'Hospedagem para um site'
    fill_in 'Código', with: 'HPPRO'
    click_on 'Salvar'

    expect(current_path).to eq product_group_path(product_group)
    expect(page).to have_content 'Grupo de produtos atualizado com sucesso'
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_content 'Hospedagem para um site'
    expect(page).to have_content 'HPPRO'
    expect(page).to have_content 'Ativo'
  end

  it 'e mantém os campos obrigatórios' do
    user = create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')
    create(:product_group, name: 'Hospedagem Pro', description: 'Hospedagem sites', code: 'HPPRO')

    login_as(user)
    visit root_path
    within 'nav.ls-menu' do
      click_on 'Grupos de Produtos'
    end
    link_to_edit.click
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível atualizar grupo de produtos.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Código não pode ficar em branco'
  end
end
