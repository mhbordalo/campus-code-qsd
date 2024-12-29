require 'rails_helper'

describe 'Vendedor informa o CPF/CNPJ do cliente' do
  context 'tendo para CPF o resultado' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      fake_response_customer = double(api_result_customer)
      allow(Faraday).to receive(:get).with(url_api_customer('87591438786')).and_return(fake_response_customer)

      visit root_path
      click_on 'Pedidos'
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'

      within('div#step_active') do
        expect(page).to have_content 'Dados do Cliente'
      end
      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_field 'creation_order[customer_identification]', disabled: true, with: '87591438786'
      expect(page).to have_field 'creation_order[customer_name]', disabled: true, with: 'José da Silva'
    end

    it 'sem sucesso quando informa um CPF faltando dígitos' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Pedidos'
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '8759143878'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'Deve ser informado um CPF ou CNPJ válido'
    end

    it 'sem sucesso quando informa um CPF inválido' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Pedidos'
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438780'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'CPF inválido'
    end

    it 'sem sucesso quando o CPF estiver bloqueado' do
      BlocklistedCustomer.create!(doc_ident: '87591438786', blocklisted_reason: 'Motivo do bloqueio')
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Pedidos'
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '87591438786'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'Este cliente está bloqueado para solicitar novos pedidos'
    end
  end

  context 'tendo para CNPJ o resultado' do
    it 'com sucesso' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)
      fake_response_customer = double(api_result_customer_cnpj)
      allow(Faraday).to receive(:get).with(url_api_customer('88212849000170')).and_return(fake_response_customer)

      visit root_path
      click_on 'Pedidos'
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '88212849000170'
      click_on 'Pesquisar Cliente'

      within('div#step_active') do
        expect(page).to have_content 'Dados do Cliente'
      end
      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_field 'creation_order[customer_identification]', disabled: true, with: '88212849000170'
      expect(page).to have_field 'creation_order[customer_name]', disabled: true, with: 'Acme Ltda'
    end

    it 'sem sucesso quando informa um CNPJ faltando dígitos ' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Pedidos'
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '8821284900017'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'Deve ser informado um CPF ou CNPJ válido'
    end

    it 'sem sucesso quando informa um CNPJ inválido' do
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Pedidos'
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '88212849000179'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'CNPJ inválido'
    end

    it 'sem sucesso quando o CNPJ estiver bloqueado' do
      BlocklistedCustomer.create!(doc_ident: '88212849000170', blocklisted_reason: 'Motivo do bloqueio')
      salesman = create(:user, name: 'Vendedor', email: 'vendedor1@locaweb.com.br', password: '12345678')
      login_as(salesman)

      visit root_path
      click_on 'Pedidos'
      click_on 'Criar Pedido'
      fill_in 'CPF (ou CNPJ)', with: '88212849000170'
      click_on 'Pesquisar Cliente'

      expect(page).not_to have_content 'Dados do cliente'
      expect(page).to have_content 'Este cliente está bloqueado para solicitar novos pedidos'
    end
  end
end
