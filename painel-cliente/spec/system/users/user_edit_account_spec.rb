require 'rails_helper'

describe 'Usuario acessa formulario de edição da conta' do
  it 'sem fazer login e é redirecionado para pagina de login' do
    visit edit_user_registration_path

    expect(page).to have_content 'Para continuar, efetue login ou registre-se.'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_link 'Login'
    expect(page).not_to have_link 'Editar Conta'
  end

  it 've os campos do formulario' do
    user = create(:user, name: 'Bruno Vulcano', email: 'user@sistema.com.br', identification: 23_318_591_084,
                         role: :client)

    login_as(user)
    visit root_path
    within('ul#user-menu') do
      click_on 'Editar Conta'
    end

    expect(current_path).to eq edit_user_registration_path
    expect(page).to have_content('Editar Conta')
    expect(page).to have_field('Nome', with: 'Bruno Vulcano')
    expect(page).to have_field('CPF/CNPJ', with: 23_318_591_084)
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('Estado')
    expect(page).to have_field('Cep')
    expect(page).to have_field('Telefone')
    expect(page).to have_field('Data Nascimento')
    expect(page).to have_field('Razão Social')
    expect(page).to have_field('E-mail', with: 'user@sistema.com.br')
    expect(page).to have_field('Nova Senha')
    expect(page).to have_field('Confirmar Nova Senha')
    expect(page).to have_field('Senha Atual')
  end

  it 'e edita com sucesso' do
    user = create(:user, name: 'Bruno Vulcano Junior', email: 'user@sistema.com.br', identification: 23_318_591_084,
                         role: :client)

    login_as(user)
    visit root_path
    click_on 'Editar Conta'

    fill_in 'Nome', with: 'Bruno Vulcano Junior'
    fill_in 'CPF/CNPJ', with: 23_318_591_084
    fill_in 'Endereço', with: ''
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'Estado', with: 'RJ'
    fill_in 'Cep', with: '22755-170'
    fill_in 'Telefone', with: '(21) 9 8897-5959'
    fill_in 'Data Nascimento', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'E-mail', with: 'user@sistema.com.br'
    fill_in 'Nova Senha', with: ''
    fill_in 'Confirmar Nova Senha', with: ''
    fill_in 'Senha Atual', with: '12345678'
    click_on 'Salvar'

    expect(current_path).to eq root_path
    expect(page).to have_content('Sua conta foi atualizada com sucesso.')
  end

  it 'e edita sem sucesso' do
    user = create(:user, name: 'Bruno Vulcano', email: 'user@sistema.com.br', identification: 23_318_591_084,
                         role: :client)

    login_as(user)
    visit root_path
    click_on 'Editar Conta'

    fill_in 'Nome', with: 'Bruno Vulcano'
    fill_in 'CPF/CNPJ', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'Cep', with: ''
    fill_in 'Telefone', with: '(21) 9 8897-5959'
    fill_in 'Data Nascimento', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'E-mail', with: 'user@sistema.com.br'
    fill_in 'Nova Senha', with: ''
    fill_in 'Confirmar Nova Senha', with: ''
    fill_in 'Senha Atual', with: '12345678'
    click_on 'Salvar'

    expect(page).to have_content('Editar Conta')
    expect(page).to have_content('Não foi possível salvar cliente')
    expect(page).to have_content('CPF/CNPJ não pode ficar em branco')
  end

  it 'e edita a senha com sucesso' do
    user = create(:user, name: 'Bruno Vulcano', email: 'user@sistema.com.br', identification: 23_318_591_084,
                         role: :client)

    login_as(user)
    visit root_path
    click_on 'Editar Conta'

    fill_in 'Nova Senha', with: 'a12345678'
    fill_in 'Confirmar Nova Senha', with: 'a12345678'
    fill_in 'Senha Atual', with: '12345678'
    click_on 'Salvar'

    expect(current_path).to eq root_path
    expect(page).to have_content('Sua conta foi atualizada com sucesso.')
  end

  it 'e edita a senha sem sucesso' do
    user = create(:user, name: 'Bruno Vulcano', email: 'user@sistema.com.br', identification: 23_318_591_084,
                         role: :client)

    login_as(user)
    visit root_path
    click_on 'Editar Conta'

    fill_in 'Nova Senha', with: 'a12345678'
    fill_in 'Confirmar Nova Senha', with: '12345678'
    fill_in 'Senha Atual', with: '12345678'
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível salvar cliente')
    expect(page).to have_content('Confirmar Senha não é igual a Senha')
  end
end
