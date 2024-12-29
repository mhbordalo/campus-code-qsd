require 'rails_helper'

describe 'Usuário visualiza lista de produtos Ativos e cancelados' do
  context 'Usuário autenticado' do
    it 'vê botão Cancelar em produtos ativos' do
      user = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)
      create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      create(:product, user:, order_code: 'XYZ999', product_plan_name: 'Plano Cloud', status: :canceled)
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('XYZ123')

      login_as(user)
      visit root_path
      click_on 'Produtos'

      within('table tbody.active') do
        expect(page).to have_button 'Cancelar'
        expect(page).to have_content 'ABC123'
        expect(page).not_to have_content 'XYZ999'
      end
    end

    it 'e não vê botão cancelar em produtos cancelados' do
      user = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)
      create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      create(:product, user:, order_code: 'XYZ999', product_plan_name: 'Plano Cloud', status: :canceled)
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('XYZ123')

      login_as(user)
      visit root_path
      click_on 'Produtos'

      within('table tbody.canceled') do
        expect(page).to have_content 'XYZ999'
        expect(page).not_to have_content 'ABC123'
        expect(page).not_to have_button 'Cancelar'
      end
    end

    it 'e cancela produto com sucesso' do
      user = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)
      create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')
      create(:product, user:, order_code: 'ABC456', product_plan_name: 'Plano 2')
      create(:product, user:, order_code: 'ABC789', product_plan_name: 'Plano 3')
      create(:product, user:, order_code: 'ABC321', product_plan_name: 'Plano 4')

      response = double('faraday_respose', status: 200, body: {})
      allow(Faraday).to receive(:post).with(
        "#{ENV.fetch('BASE_URL_PRODUCTS')}/uninstall",
        { customer_document: 23_318_591_084, order_code: 'ABC123', plan_name: 'Plano 1' }.to_json,
        { 'Content-Type': 'application/json' }
      ).and_return(response)

      login_as(user)
      visit root_path
      click_on 'Produtos'
      within('table tbody.active tr:nth-child(1)') do
        click_on 'Cancelar'
      end

      expect(page).to have_content 'Produto cancelado com sucesso'
      within('table tbody.canceled') do
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Plano 1'
        expect(page).to have_content 'Cancelado'
      end
    end

    it 'recebe erro 404' do
      user = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)
      create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')
      create(:product, user:, order_code: 'ABC456', product_plan_name: 'Plano 2')
      create(:product, user:, order_code: 'ABC789', product_plan_name: 'Plano 3')
      create(:product, user:, order_code: 'ABC321', product_plan_name: 'Plano 4')

      response = double('faraday_respose', status: 404, body: {})
      allow(Faraday).to receive(:post).with(
        "#{ENV.fetch('BASE_URL_PRODUCTS')}/uninstall",
        { customer_document: 23_318_591_084, order_code: 'ABC123', plan_name: 'Plano 1' }.to_json,
        { 'Content-Type': 'application/json' }
      ).and_return(response)

      login_as(user)
      visit root_path
      click_on 'Produtos'
      within('table tbody.active tr:nth-child(1)') do
        click_on 'Cancelar'
      end

      expect(page).to have_content 'Erro ao cancelar produto'
      within('table tbody.active') do
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Plano 1'
        expect(page).to have_content 'Ativo'
      end
    end

    it 'recebe erro 500' do
      user = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)
      create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')
      create(:product, user:, order_code: 'ABC456', product_plan_name: 'Plano 2')
      create(:product, user:, order_code: 'ABC789', product_plan_name: 'Plano 3')
      create(:product, user:, order_code: 'ABC321', product_plan_name: 'Plano 4')

      response = double('faraday_respose', status: 500, body: {})
      allow(Faraday).to receive(:post).with(
        "#{ENV.fetch('BASE_URL_PRODUCTS')}/uninstall",
        { customer_document: 23_318_591_084, order_code: 'ABC123', plan_name: 'Plano 1' }.to_json,
        { 'Content-Type': 'application/json' }
      ).and_return(response)

      login_as(user)
      visit root_path
      click_on 'Produtos'
      within('table tbody.active tr:nth-child(1)') do
        click_on 'Cancelar'
      end

      expect(page).to have_content 'Erro ao cancelar produto'
      within('table tbody.active') do
        expect(page).to have_content 'ABC123'
        expect(page).to have_content 'Plano 1'
        expect(page).to have_content 'Ativo'
      end
    end
  end
end
