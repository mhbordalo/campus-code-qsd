require 'rails_helper'

describe 'Usuário vê periodicidades' do
  it 'e não esta logado ' do
    visit periodicities_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'do menu de navegação' do
    user = create(:user)

    login_as user
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')

    expect(page).to have_content('Periodicidades')
  end

  it 'e vê as periodicidades cadastradas' do
    user = create(:user)
    create(:periodicity, name: 'Mensal', deadline: 1)
    create(:periodicity, name: 'Trimestral', deadline: 3)
    create(:periodicity, name: 'Semestral', deadline: 6)

    login_as user
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')

    expect(page).to have_content('Mensal')
    expect(page).to have_content('Trimestral')
    expect(page).to have_content('Semestral')
    expect(page).to have_content('1')
    expect(page).to have_content('3')
    expect(page).to have_content('6')
  end

  it 'e não existem periodicidades cadastradas' do
    user = create(:user)

    login_as user
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')

    expect(page).to have_content('Não há Periodicidades cadastradas.')
  end
end
