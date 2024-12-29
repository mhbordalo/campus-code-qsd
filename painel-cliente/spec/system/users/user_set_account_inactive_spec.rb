require 'rails_helper'

describe 'Usuário acessa página de "cancelamento" da conta' do
  context 'e sem estar logado' do
    it 'e é redirecionado para o login' do
      visit root_path
      visit users_inactive_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end
  context 'e estando autenticado' do
    it 'e vê a página de inativar a conta' do
      user = create(:user, identification: 23_318_591_084, role: :client)

      login_as(user)
      visit root_path
      click_on 'Inativar Conta'

      expect(current_path).to eq users_inactive_path
      expect(page).to have_content('Inativar Conta')
      expect(page).to have_button('Inativar Minha Conta')
    end

    it 'inativa sua conta com sucesso' do
      user = create(:user, identification: 23_318_591_084, role: :client)

      login_as(user)
      visit root_path
      click_on 'Inativar Conta'
      click_on 'Inativar Minha Conta'

      expect(current_path).to eq new_user_session_path
      expect(page).to have_link('Login')
      expect(page).to have_content('Sua conta foi inativada com sucesso!')
    end
  end

  context 'e sendo administrador, logado' do
    it 'não consegue ver opção de inativar a conta' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)

      login_as(user)
      visit root_path

      expect(page).to have_link 'Editar Conta'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_link 'Inativar Conta'
    end
  end
end
