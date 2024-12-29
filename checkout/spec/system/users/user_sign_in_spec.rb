require 'rails_helper'

describe 'User faz login' do
  it 'com sucesso' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')

    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Login'
    end

    expect(page).to have_css('div.notice', text: 'Login efetuado com sucesso.')
    expect(page).to have_content('Usuário Teste (user@locaweb.com.br)')
  end

  it 'com e-mail não cadastrado' do
    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Login'
    end

    expect(page).to have_css('div.alert', text: 'E-mail ou senha inválidos.')
  end

  it 'não estando ativo no sistema' do
    create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678',
                  active: false)

    visit root_path
    within('div#user-account') do
      click_on 'Login'
    end
    within('form#new_user') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Login'
    end

    expect(page).to have_css('div.alert', text: 'A sua conta não está ativada.')
  end
end
