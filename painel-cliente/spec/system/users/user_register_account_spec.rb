require 'rails_helper'

describe 'Usuario acessa formulario de criação da conta' do
  it 've os campos do formulario' do
    visit root_path
    click_on 'Login'
    click_on 'Cadastre-se agora'

    expect(current_path).to eq new_user_registration_path
    expect(page).to have_content('Criar Conta')
    expect(page).to have_field('Nome')
    expect(page).to have_field('CPF/CNPJ')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('Estado')
    expect(page).to have_field('Cep')
    expect(page).to have_field('Telefone')
    expect(page).to have_field('Data Nascimento')
    expect(page).to have_field('Razão Social')
    expect(page).to have_field('E-mail')
    expect(page).to have_field('Senha')
  end

  it 'e cria uma conta com sucesso' do
    json = Rails.root.join('spec/support/json/pending_orders.json').read
    response = double('faraday_response', status: 200, body: json)
    url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/62429965704/orders"
    allow(Faraday).to receive(:get).with(url).and_return(response)

    visit root_path
    click_on 'Login'
    click_on 'Cadastre-se agora'

    expect(page).to have_content('Criar Conta')
    fill_in 'Nome', with: 'Bruno Vulcano'
    fill_in 'CPF/CNPJ', with: 62_429_965_704
    fill_in 'Endereço', with: 'Rua dos Girassois, 345. Jardim Belo'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'Estado', with: 'RJ'
    fill_in 'Cep', with: '04310-060'
    fill_in 'Telefone', with: '(33) 8 9876-0220'
    fill_in 'Data Nascimento', with: '01/06/1970'
    fill_in 'Razão Social', with: 'Vulcano SA'
    fill_in 'E-mail', with: 'brunovulcano@locaweb.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar Senha', with: '123456'

    click_on 'Salvar'

    msg = 'Login efetuado com sucesso. Se não foi autorizado, a confirmação será enviada por e-mail.'
    expect(page).to have_content msg
    expect(page).to have_button 'Sair'
  end
  it 'e não consegue criar a conta' do
    visit root_path
    click_on 'Login'
    click_on 'Cadastre-se agora'

    expect(page).to have_content('Criar Conta')
    fill_in 'Nome', with: ''
    fill_in 'CPF/CNPJ', with: ''
    fill_in 'Endereço', with: 'Rua dos Girassois, 345. Jardim Belo'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'Estado', with: 'RJ'
    fill_in 'Cep', with: '04310-060'
    fill_in 'Telefone', with: '(33) 9 9876-0220'
    fill_in 'Data Nascimento', with: '01/06/1970'
    fill_in 'Razão Social', with: 'Vulcano SA'
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirmar Senha', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível salvar cliente'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'CPF/CNPJ não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).not_to have_button 'Sair'
  end
end
