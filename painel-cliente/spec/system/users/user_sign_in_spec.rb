require 'rails_helper'

describe 'User faz login' do
  it 'com sucesso' do
    user = create(:user, email: 'user@sistema.com.br')
    json = Rails.root.join('spec/support/json/pending_orders.json').read
    response = double('faraday_response', status: 200, body: json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response)

    visit root_path
    click_on 'Login'
    fill_in 'E-mail', with: 'user@sistema.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_content('Login efetuado com sucesso!')
  end

  it 'com e-mail não cadastrado' do
    visit root_path
    click_on 'Login'
    fill_in 'E-mail', with: 'user@sistema.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_css('div.alert', text: 'E-mail ou senha inválida')
  end

  it 'e faz o log-out' do
    user = create(:user, email: 'user@sistema.com.br')
    json = Rails.root.join('spec/support/json/pending_orders.json').read
    response = double('faraday_response', status: 200, body: json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response)

    visit root_path
    click_on 'Login'
    fill_in 'E-mail', with: 'user@sistema.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'
    click_on 'Sair'

    expect(page).to have_content 'Saiu com sucesso.'
    expect(current_path).to eq new_user_session_path
  end

  it 'com a conta desativada' do
    create(:user, email: 'user@sistema.com.br', status: :inactive)

    visit root_path
    click_on 'Login'
    fill_in 'E-mail', with: 'user@sistema.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_content 'Conta inativa! Por favor usar outra conta.'
    expect(current_path).to eq new_user_session_path
  end

  it 'como administrador com email locaweb' do
    create(:user, email: 'user@locaweb.com.br', role: :administrator)

    visit root_path
    click_on 'Login'
    fill_in 'E-mail', with: 'user@locaweb.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_css('div.notice', text: 'Login efetuado com sucesso!')
    expect(current_path).to eq calls_path
  end

  it 'como administrador sem email locaweb' do
    create(:user, email: 'user@sistema.com.br', role: :administrator)

    visit root_path
    click_on 'Login'
    fill_in 'E-mail', with: 'user@sistema.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(page).to have_content('Dominio do email não e valido para administrador !!!!')
    expect(current_path).to eq new_user_session_path
  end
end
