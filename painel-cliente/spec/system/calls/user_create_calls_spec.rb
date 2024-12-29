require 'rails_helper'

describe 'Usuário cria chamados' do
  context 'não autenticado' do
    it 'redireciona para login se acessar diretamente' do
      visit new_call_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end

  context 'autenticado como administrador' do
    it 'e não consegue criar chamados pelo menu' do
      user = create(:user, role: :administrator)

      login_as(user)
      visit root_path
      click_on 'Chamados'

      expect(page).not_to have_content('Novo Chamado')
    end

    it 'e não consegue criar chamados acessando a rota diretamente' do
      user = create(:user, role: :administrator)

      login_as(user)
      visit new_call_path

      expect(page).to have_content('Você não tem permissão para acessar essa página')
    end
  end

  context 'autenticado como cliente' do
    it 'e visualiza a página e o formulário' do
      user = create(:user)

      login_as(user)
      visit root_path
      click_on 'Chamados'
      click_on 'Novo Chamado'

      expect(current_path).to eq new_call_path
      expect(page).to have_content 'Novo Chamado'

      expect(page).to have_field 'Produto - Pedido'
      expect(page).to have_field 'Categoria'
      expect(page).to have_field 'Assunto'
      expect(page).to have_field 'Descrição'
      expect(page).to have_button 'Salvar'
    end

    it 'cria chamado para produtos instalados com sucesso' do
      user = create(:user)
      create(:call_category, description: 'Financeiro')
      create(:call_category, description: 'Suporte Técnico')
      create(:product, user:, installation: 5, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      create(:product, user:, installation: 5, order_code: 'ABC456', product_plan_name: 'Plano Hospedagem I')
      allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

      login_as(user)
      visit root_path
      click_on 'Chamados'
      click_on 'Novo Chamado'
      select 'Plano Hospedagem I - ABC123', from: 'Produto - Pedido'
      select 'Financeiro', from: 'Categoria'
      fill_in 'Assunto', with: 'Cartão recusando a compra'
      fill_in 'Descrição', with: 'O sistema está recusando meu cartão de crédito'
      click_on 'Salvar'

      expect(current_path).to eq calls_path
      expect(page).to have_content 'Chamados'
      within('table thead tr') do
        expect(page).to have_content 'Data'
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Assunto'
        expect(page).to have_content 'Produto - Pedido'
        expect(page).to have_content 'Categoria'
        expect(page).to have_content 'Status'
      end
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content Time.zone.today.strftime('%d/%m/%Y')
        expect(page).to have_content 'XYZ123'
        expect(page).to have_content 'Cartão recusando a compra'
        expect(page).to have_content 'Plano Hospedagem I - ABC123'
        expect(page).to have_content 'Financeiro'
        expect(page).to have_content 'Aberto'
        expect(page).to have_content 'Encerrar'
      end
      within('table') do
        expect(page).not_to have_content 'Plano Hospedagem I - ABC456'
      end
    end

    it 'e produtos não instalados não aparecem no select, impedindo abertura de chamado' do
      user = create(:user)
      create(:product, user:, installation: 5, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      create(:product, user:, installation: 5, order_code: 'WYZ917', product_plan_name: 'Plano Hospedagem Gold')
      create(:product, user:, installation: 0, order_code: 'ABC456', product_plan_name: 'Plano Hospedagem I')
      create(:product, user:, installation: 0, order_code: 'ABC789', product_plan_name: 'Plano Hospedagem II')

      login_as(user)
      visit root_path
      click_on 'Chamados'
      click_on 'Novo Chamado'

      expect(page).to have_field('Produto - Pedido', text: 'Plano Hospedagem I - ABC123')
      expect(page).to have_field('Produto - Pedido', text: 'Plano Hospedagem Gold - WYZ917')
      expect(page).not_to have_field('Produto - Pedido', text: 'Plano Hospedagem I - ABC456')
      expect(page).not_to have_field('Produto - Pedido', text: 'Plano Hospedagem II - ABC789')
    end

    it 'e mantém os campos obrigatórios' do
      user = create(:user)
      create(:call_category, description: 'Financeiro')
      create(:call_category, description: 'Suporte Técnico')
      create(:product, user:, installation: 5, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      create(:product, user:, installation: 5, order_code: 'ABC456', product_plan_name: 'Plano Hospedagem I')
      allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

      login_as(user)
      visit root_path
      click_on 'Chamados'
      click_on 'Novo Chamado'
      select '', from: 'Produto'
      select '', from: 'Categoria'
      fill_in 'Assunto', with: ''
      fill_in 'Descrição', with: ''
      click_on 'Salvar'

      expect(page).to have_content 'Novo Chamado'
      within('div.alert') do
        expect(page).to have_content 'Erro ao criar chamado'
      end
      within('ul.messages') do
        expect(page).to have_content 'Call category é obrigatório(a)'
        expect(page).to have_content 'Assunto não pode ficar em branco'
        expect(page).to have_content 'Descrição não pode ficar em branco'
      end
    end
  end
end
