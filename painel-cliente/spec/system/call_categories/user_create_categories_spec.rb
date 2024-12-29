require 'rails_helper'

describe 'Usuário cria categorias' do
  context 'autenticado como cliente' do
    it 'acessando a rota diretamente' do
      user = create(:user, identification: 23_318_591_084, role: :client)

      login_as(user)
      visit new_call_category_path

      expect(page).to have_content('Você não tem permissão para acessar essa página')
    end
  end

  context 'autenticado como administrador' do
    it 'e visualiza a página e o formulário' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)

      login_as(user)
      visit root_path
      click_on 'Categorias'
      click_on 'Nova Categoria'

      expect(current_path).to eq new_call_category_path
      expect(page).to have_content 'Nova Categoria'
      expect(page).to have_field 'Descrição'
      expect(page).to have_button 'Salvar'
    end

    it 'cria categorias com sucesso' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)

      login_as(user)
      visit root_path
      click_on 'Categorias'
      click_on 'Nova Categoria'
      fill_in 'Descrição', with: 'Financeiro'
      click_on 'Salvar'

      expect(current_path).to eq call_categories_path
      expect(page).to have_content 'Categorias'
      within('table thead tr:nth-child(1)') do
        expect(page).to have_content 'Categorias'
        expect(page).to have_content 'Ações'
      end
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content 'Financeiro'
        expect(page).to have_button 'Editar'
      end
    end

    it 'e cria com campo vazio' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)

      login_as(user)
      visit root_path
      click_on 'Categorias'
      click_on 'Nova Categoria'
      fill_in 'Descrição', with: ''
      click_on 'Salvar'

      expect(page).to have_content 'Descrição não pode ficar em branco'
    end
  end
end
