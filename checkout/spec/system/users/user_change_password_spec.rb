require 'rails_helper'

describe 'usuário troca sua senha' do
  it 'e vê botão de troca de senha' do
    user = create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    login_as(user)

    visit root_path

    expect(page).to have_button 'Alterar Senha'
  end

  it 'e vê formulário ao clicar no botão de troca de senha' do
    user = create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    login_as(user)

    visit root_path
    click_on 'Alterar Senha'

    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
    expect(page).to have_button 'Salvar'
  end

  it 'e troca a senha com sucesso' do
    user = create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    login_as(user)

    visit root_path
    click_on 'Alterar Senha'
    fill_in 'Senha', with: '87654321'
    fill_in 'Confirme sua senha', with: '87654321'
    click_on 'Salvar'

    expect(page).to have_content 'Senha alterada com sucesso'
    expect(current_path).to eq new_user_session_path
  end
end
