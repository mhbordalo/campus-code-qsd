require 'rails_helper'

describe 'Usuário autorizado registra periodicidade' do
  it 'e não esta logado' do
    visit new_periodicity_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'a partir da tela principal' do
    user = create(:user)

    login_as user
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')
    click_on 'Cadastrar novo'

    expect(page).to have_content('Periodicidade')
    expect(page).to have_field('Nome')
    expect(page).to have_field('Prazo')
  end

  it 'com sucesso' do
    user = create(:user)

    login_as user
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')
    click_on 'Cadastrar novo'
    fill_in 'Nome', with: 'Mensal'
    fill_in 'Prazo', with: '1'
    click_on 'Salvar'

    expect(page).to have_content 'Periodicidade cadastrada com sucesso.'
    expect(page).to have_content 'Mensal'
    expect(page).to have_content '1'
  end

  it 'e deixa campos obrigatórios em branco' do
    user = create(:user)

    login_as user
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')
    click_on 'Cadastrar novo'
    fill_in 'Nome', with: ''
    fill_in 'Prazo', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível cadastrar periodicidade.')
    expect(page).not_to have_content('Periodicidade cadastrada com sucesso.')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Prazo não pode ficar em branco')
  end

  it 'e cancela a operação' do
    login
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')
    click_on 'Cadastrar novo'
    fill_in 'Nome', with: 'Trimestral'
    fill_in 'Prazo', with: '3'
    click_on 'Cancelar'

    expect(current_path).to eq periodicities_path
    expect(page).to have_content('Não há Periodicidades cadastradas.')
    expect(page).not_to have_content 'Não foi possível cadastrar periodicidade.'
    expect(page).not_to have_content 'Periodicidade cadastrada com sucesso.'
    expect(page).not_to have_content 'Trimestral'
  end
end
