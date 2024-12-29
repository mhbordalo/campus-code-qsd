require 'rails_helper'

describe 'Usuário visualiza produtos ' do
  context 'usuário não autenticado' do
    it 'não consegue acessar seção sem se logar' do
      visit root_path

      expect(page).not_to have_content('Produtos')
    end
    it 'redireciona para login se acessar diretamente' do
      visit products_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end

  context 'usuário autenticado' do
    it 'visualiza o produto cadastrados com sucesso' do
      user = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)
      create(:product, order_code: 'ABC123', user:,
                       product_plan_name: 'Plano Hospedagem I',
                       purchase_date: '2023-01-30',
                       status: :active, installation: :uninstalled)
      create(:product, order_code: 'ABC456', user:,
                       product_plan_name: 'Plano Cloud',
                       purchase_date: '2023-01-30',
                       status: :canceled, installation: :uninstalled)

      login_as(user)
      visit root_path
      click_on 'Produtos'

      within('h2.active') do
        expect(page).to have_content('Ativos')
      end
      within('table thead.active tr') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Instalação'
        expect(page).to have_content 'Data da Compra'
      end
      within('table tbody.active') do
        expect(page).to have_content 'Plano Hospedagem I'
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Ativo'
        expect(page).to have_content 'Não instalado'
        expect(page).to have_content '30/01/2023'
      end
      within('h2.canceled') do
        expect(page).to have_content('Cancelados')
      end
      within('table thead.canceled tr') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Instalação'
        expect(page).to have_content 'Data da Compra'
      end
      within('table tbody.canceled') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'ABC456'
        expect(page).to have_content 'Cancelado'
        expect(page).to have_content 'Não instalado'
        expect(page).to have_content '30/01/2023'
      end
    end

    it 'e não tem produtos instalados ' do
      user = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)

      login_as(user)
      visit root_path
      click_on 'Produtos'

      expect(page).to have_content 'Não existem produtos instalados!'
    end
  end
end

describe 'Administrador visualiza produtos' do
  context 'Administrador autenticado' do
    it 'não vê botão cancelar nem o botão renovar' do
      user1 = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)
      user2 = create(:user, name: 'Maria do Socorro', identification: 55_149_912_026, role: :client)
      user3 = create(:user, name: 'João Andrade', identification: 62_429_965_704, role: :administrator)
      create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I',
                       installation: :uninstalled)
      create(:product, user: user2, order_code: 'ABC456', product_plan_name: 'Plano Cloud', installation: :uninstalled)
      create(:product, user: user2, order_code: 'XYZ789', product_plan_name: 'Plano Cloud', status: :canceled,
                       installation: :uninstalled)

      login_as(user3)
      visit root_path
      click_on 'Produtos'

      within('h2.active') do
        expect(page).to have_content('Ativos')
      end
      within('table thead.active tr') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Instalação'
        expect(page).to have_content 'Data da Compra'
      end
      within('table tbody.active') do
        expect(page).to have_content 'Plano Hospedagem I'
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Ativo'
        expect(page).not_to have_button 'Cancelar'
        expect(page).not_to have_button 'Renovar'
      end
      within('table tbody.active') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'ABC456'
        expect(page).to have_content 'Ativo'
        expect(page).not_to have_button 'Cancelar'
        expect(page).not_to have_button 'Renovar'
      end
      within('h2.canceled') do
        expect(page).to have_content('Cancelados')
      end
      within('table thead.canceled tr') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
      end
      within('table tbody.canceled') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'XYZ789'
        expect(page).to have_content 'Cancelado'
        expect(page).not_to have_button 'Cancelar'
        expect(page).not_to have_button 'Renovar'
      end
    end

    it 'vê o nome do cliente em produtos ativos' do
      user1 = create(:user, name: 'José da Silva', identification: 23_318_591_084, role: :client)
      user2 = create(:user, name: 'Adriana dos Santos', identification: 55_149_912_026, role: :client)
      user3 = create(:user, name: 'João Andrade', identification: 62_429_965_704, role: :administrator)
      create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I',
                       installation: :uninstalled)
      create(:product, user: user2, order_code: 'ABC456', product_plan_name: 'Plano Cloud', installation: :uninstalled)
      create(:product, user: user2, order_code: 'XYZ789', product_plan_name: 'Plano Cloud', installation: :uninstalled)

      login_as(user3)
      visit root_path
      click_on 'Produtos'

      within('h2.active') do
        expect(page).to have_content('Ativos')
      end
      within('table thead.active tr') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Cliente'
      end
      within('table tbody.active') do
        expect(page).to have_content 'Plano Hospedagem I'
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Ativo'
        expect(page).to have_content 'José da Silva'
      end
      within('table tbody.active') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'ABC456'
        expect(page).to have_content 'Ativo'
        expect(page).to have_content 'Adriana dos Santos'
      end

      within('table tbody.active') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'XYZ789'
        expect(page).to have_content 'Ativo'
        expect(page).to have_content 'Adriana dos Santos'
      end
    end

    it 'vê o nome do cliente em produtos cancelados' do
      user1 = create(:user, name: 'José da Silva', identification: 23_318_591_084, role: :client)
      user2 = create(:user, name: 'Adriana dos Santos', identification: 55_149_912_026, role: :client)
      user3 = create(:user, name: 'João Andrade', identification: 62_429_965_704, role: :administrator)
      create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I', status: :canceled,
                       installation: :uninstalled)
      create(:product, user: user2, order_code: 'ABC456', product_plan_name: 'Plano Cloud', status: :canceled,
                       installation: :uninstalled)
      create(:product, user: user2, order_code: 'XYZ789', product_plan_name: 'Plano Cloud', status: :canceled,
                       installation: :uninstalled)

      login_as(user3)
      visit root_path
      click_on 'Produtos'

      within('h2.canceled') do
        expect(page).to have_content('Cancelados')
      end
      within('table thead.canceled tr') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Cliente'
      end
      within('table tbody.canceled') do
        expect(page).to have_content 'Plano Hospedagem I'
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Cancelado'
        expect(page).to have_content 'José da Silva'
      end
      within('table tbody.canceled') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'ABC456'
        expect(page).to have_content 'Cancelado'
        expect(page).to have_content 'Adriana dos Santos'
      end
      within('table tbody.canceled') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'XYZ789'
        expect(page).to have_content 'Cancelado'
        expect(page).to have_content 'Adriana dos Santos'
      end
    end

    it 'vê o nome do cliente em ordem alfabetica em produtos ativos' do
      user1 = create(:user, name: 'José da Silva', identification: 23_318_591_084, role: :client)
      user2 = create(:user, name: 'Adriana dos Santos', identification: 55_149_912_026, role: :client)
      user3 = create(:user, name: 'João Andrade', identification: 62_429_965_704, role: :administrator)
      create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      create(:product, user: user2, order_code: 'ABC456', product_plan_name: 'Plano Cloud')
      create(:product, user: user2, order_code: 'XYZ789', product_plan_name: 'Plano Email')
      create(:product, user: user1, order_code: 'DEF111', product_plan_name: 'Plano MKT')

      login_as(user3)
      visit root_path
      click_on 'Produtos'

      within('h2.active') do
        expect(page).to have_content('Ativos')
      end
      within('table thead.active tr') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Cliente'
      end
      within('table tbody.active tr:nth-child(1)') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'ABC456'
        expect(page).to have_content 'Ativo'
        expect(page).to have_content 'Adriana dos Santos'
      end
      within('table tbody.active tr:nth-child(2)') do
        expect(page).to have_content 'Plano Email'
        expect(page).to have_content 'XYZ789'
        expect(page).to have_content 'Ativo'
        expect(page).to have_content 'Adriana dos Santos'
      end
      within('table tbody.active tr:nth-child(3)') do
        expect(page).to have_content 'Plano Hospedagem I'
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Ativo'
        expect(page).to have_content 'José da Silva'
      end
      within('table tbody.active tr:nth-child(4)') do
        expect(page).to have_content 'Plano MKT'
        expect(page).to have_content 'DEF111'
        expect(page).to have_content 'Ativo'
        expect(page).to have_content 'José da Silva'
      end
    end

    it 'vê o nome do cliente em ordem alfabetica em produtos cancelados' do
      user1 = create(:user, name: 'José da Silva', identification: 23_318_591_084, role: :client)
      user2 = create(:user, name: 'Adriana dos Santos', identification: 55_149_912_026, role: :client)
      user3 = create(:user, name: 'João Andrade', identification: 62_429_965_704, role: :administrator)
      create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I', status: :canceled,
                       installation: :uninstalled)
      create(:product, user: user2, order_code: 'ABC456', product_plan_name: 'Plano Cloud', status: :canceled,
                       installation: :uninstalled)
      create(:product, user: user2, order_code: 'XYZ789', product_plan_name: 'Plano Email', status: :canceled,
                       installation: :uninstalled)

      login_as(user3)
      visit root_path
      click_on 'Produtos'

      within('h2.canceled') do
        expect(page).to have_content('Cancelados')
      end
      within('table thead.canceled tr') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Cliente'
      end
      within('table tbody.canceled tr:nth-child(1)') do
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'ABC456'
        expect(page).to have_content 'Cancelado'
        expect(page).to have_content 'Adriana dos Santos'
      end
      within('table tbody.canceled tr:nth-child(2)') do
        expect(page).to have_content 'Plano Email'
        expect(page).to have_content 'XYZ789'
        expect(page).to have_content 'Cancelado'
        expect(page).to have_content 'Adriana dos Santos'
      end
      within('table tbody.canceled tr:nth-child(3)') do
        expect(page).to have_content 'Plano Hospedagem I'
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Cancelado'
        expect(page).to have_content 'José da Silva'
      end
    end
  end
end
