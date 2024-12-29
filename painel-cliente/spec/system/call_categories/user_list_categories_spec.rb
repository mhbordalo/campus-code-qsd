require 'rails_helper'

describe 'Usuário lista categorias' do
  context 'não autenticado' do
    it 'não consegue acessar seção' do
      visit root_path

      expect(page).not_to have_content('Categorias')
    end

    it 'redireciona para login se acessar diretamente' do
      visit call_categories_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end

  context 'autenticado como cliente' do
    it 'não consegue acessar o menu categorias' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      create(:call_category, description: 'Cobrança')
      create(:call_category, description: 'Suporte Técnico')

      login_as(user)
      visit root_path

      expect(current_path).to eq root_path
      expect(page).not_to have_content 'Categorias'
    end

    it 'acessando a rota diretamente' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      create(:call_category, description: 'Cobrança')
      create(:call_category, description: 'Suporte Técnico')

      login_as(user)
      visit call_categories_path

      expect(page).to have_content('Você não tem permissão para acessar essa página')
    end
  end

  context 'autenticado como administrador' do
    it 'consegue acessar o menu categorias' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)
      create(:call_category, description: 'Cobrança')
      create(:call_category, description: 'Suporte Técnico')

      login_as(user)
      visit root_path

      expect(page).to have_content 'Categorias'
    end

    it 'e visualiza categorias com sucesso' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)
      create(:call_category, description: 'Cobrança')
      create(:call_category, description: 'Suporte Técnico')

      login_as(user)
      visit root_path
      click_on 'Categorias'

      expect(page).to have_content('Categorias')
      expect(page).to have_content('Cobrança')
      expect(page).to have_content('Suporte Técnico')
    end

    it 'e não existe categorias cadastradas' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)

      login_as(user)
      visit root_path
      click_on 'Categorias'

      expect(page).to have_content('Categorias')
      expect(page).to have_content('Nenhuma categoria cadastrada')
    end
  end
end
