require 'rails_helper'

describe 'User faz login' do
  it 'com sucesso' do
    create(:user, email: 'user@locaweb.com.br', password: '12345678')
    visit root_path

    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Entrar'
    end

    expect(page).to have_css('div.notice', text: 'Login efetuado com sucesso.')
  end

  it 'com e-mail não cadastrado' do
    visit root_path

    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'user@sistema.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Entrar'
    end

    expect(page).to have_css('div.alert', text: 'E-mail ou senha inválidos.')
  end

  it 'e faz logout' do
    create(:user, email: 'user@locaweb.com.br', password: '12345678')
    visit root_path

    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'user@locaweb.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Entrar'
    end

    click_on 'Sair'

    within('div.alert') do
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end
  end

  it 'e tenta se cadastrar com um e-mail não permitido' do
    visit root_path

    click_on 'Cadastro'
    within('form') do
      fill_in 'E-mail', with: 'user@sistema.com.br'
      fill_in 'Senha', with: '12345678'
      fill_in 'Confirme sua senha', with: '12345678'
      click_on 'Cadastrar'
    end
    expect(page).to have_content 'E-mail não possui um domínio válido.'
  end
end
