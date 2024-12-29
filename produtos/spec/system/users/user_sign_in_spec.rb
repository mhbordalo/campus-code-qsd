require 'rails_helper'

describe 'User faz login' do
  it 'com sucesso' do
    create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')
    visit root_path

    click_on 'Entrar'
    fill_in 'E-mail', with: 'user@locaweb.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_css('div.notice', text: 'Login efetuado com sucesso.')
  end

  it 'com e-mail não cadastrado' do
    visit root_path

    click_on 'Entrar'
    fill_in 'E-mail', with: 'user@locaweb.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_css('div.ls-alert-danger', text: 'E-mail ou senha inválida.')
  end

  it 'com e-mail dominio locaweb.com.br' do
    visit root_path

    click_on 'Entrar'
    fill_in 'E-mail', with: 'user@locaweb.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_css('div.alert', text: 'E-mail ou senha inválida.')
  end

  it 'Usuário faz logout com sucesso' do
    create(:user, name: 'Maria', email: 'user@locaweb.com.br', password: '12345678')

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'user@locaweb.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    click_on 'Sair'
    expect(page).to have_button 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'user@locaweb.com.br'
  end
end
