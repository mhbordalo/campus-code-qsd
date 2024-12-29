require 'rails_helper'

describe 'Usuário edita categorias' do
  context 'não autenticado' do
    it 'redireciona para login se acessar diretamente' do
      category = create(:call_category, description: 'Cobrança')

      visit edit_call_category_path(category.id)

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end

  context 'autenticado como cliente' do
    it 'acessando a rota diretamente' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      category = create(:call_category, description: 'Cobrança')
      create(:call_category, description: 'Suporte Técnico')

      login_as(user)
      visit edit_call_category_path(category.id)

      expect(page).to have_content('Você não tem permissão para acessar essa página')
    end
  end

  context 'autenticado como administrador' do
    it 'e visualiza a página e o formulário' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)
      category = create(:call_category, description: 'Cobrança')
      create(:call_category, description: 'Suporte Técnico')

      login_as(user)
      visit root_path
      click_on 'Categorias'
      within('table tbody tr:nth-child(1)') do
        click_on 'Editar'
      end

      expect(current_path).to eq edit_call_category_path(category.id)
      expect(page).to have_field 'Descrição', with: 'Cobrança'
      expect(page).to have_button 'Salvar'
    end

    it 'edita categorias com sucesso' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)
      create(:call_category, description: 'Cobrança')
      create(:call_category, description: 'Suporte Técnico')

      login_as(user)
      visit root_path
      click_on 'Categorias'
      within('table tbody tr:nth-child(1) td:nth-child(2)') do
        click_on 'Editar'
      end
      fill_in 'Descrição', with: 'Financeiro'
      click_on 'Salvar'

      expect(current_path).to eq call_categories_path
      within('table thead tr:nth-child(1)') do
        expect(page).to have_content 'Categorias'
        expect(page).to have_content 'Ações'
      end
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content 'Financeiro'
        expect(page).to have_button 'Editar'
      end
      expect(page).not_to have_content 'Cobrança'
    end

    it 'e edita com campo vazio' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)
      category = create(:call_category, description: 'Cobrança')

      login_as(user)
      visit root_path
      click_on 'Categorias'
      within('table tbody tr:nth-child(1) td:nth-child(2)') do
        click_on 'Editar'
      end
      fill_in 'Descrição', with: ''
      click_on 'Salvar'

      expect(current_path).to eq call_category_path(category.id)
      expect(page).to have_content 'Descrição não pode ficar em branco'
    end
  end
end
