require 'rails_helper'

describe 'User faz logout' do
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
    within('div#user-account') do
      click_on 'Logout'
    end

    expect(page).to have_css('div.notice', text: 'Logout efetuado com sucesso.')
    expect(page).to have_content('Não conectado')
  end
end
