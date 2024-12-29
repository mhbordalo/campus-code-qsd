require 'rails_helper'

describe 'Usuário vai para tela de pagamento de pedido pendente' do
  context 'estando não autenticado,' do
    it 'é redirecionado para tela de login' do
      visit orders_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end

  context 'estando autenticado,' do
    it 'seleciona um pedido pendente e visualiza seus meios de pagamento' do
      user = create(:user, identification: 62_429_965_704)
      create(:credit_card, user:)
      create(:credit_card, token: 'kh45234vb234m', card_number: '9811', credit_card_flag: 'Visa', user:)

      pending_orders_json = Rails.root.join('spec/support/json/pending_orders.json').read
      response = double('faraday_response', status: 200, body: pending_orders_json)
      checkout_url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
      allow(Faraday).to receive(:get).with(checkout_url).and_return(response)

      charge_url = ENV.fetch('BASE_URL_CHARGES')
      charge_response = double('charge_response', status: 200, body: {}.to_json)
      allow(Faraday).to receive(:post).with(charge_url).and_return(charge_response)

      login_as(user)
      visit(orders_path)
      within('table tr:nth-child(2)') do
        click_on('Pagar')
      end

      expect(current_path).to eq checkout_order_path(2)
      expect(page).to have_content('Pagamento do Pedido: N5KDI4HLYH')
      expect(page).to have_content('Plano: Plano Prata')
      expect(page).to have_content('Preço: R$ 50,00')
      expect(page).to have_content('Periodicidade: Mensal')
      expect(page).to have_field('Selecionar Cartão:')
      expect(page).to have_field('Número de Parcelas:')
      expect(page).to have_content('Desconto via Cupom: 0,0%')
      expect(page).to have_content('Valor total a Pagar: R$ 50,00')
      expect(page).to have_button('Confirmar')
      expect(page).to have_link('Voltar')
    end

    it 'efetua uma requisição de pagamento com sucesso' do
      user = create(:user, identification: 62_429_965_704)
      create(:credit_card, user:)
      create(:credit_card, token: 'kh45234vb234m', card_number: '9811', credit_card_flag: 'Visa', user:)

      pending_orders_json = Rails.root.join('spec/support/json/pending_orders.json').read
      pending_orders_response = double('faraday_response', status: 200, body: pending_orders_json)
      pending_orders_url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
      allow(Faraday).to receive(:get).with(pending_orders_url).and_return(pending_orders_response)

      charge_url = "#{ENV.fetch('BASE_URL_CHARGES')}/charges"

      parametro = { charge: { creditcard_token: 'kh45234vb234m',
                              client_cpf: '62429965704',
                              order: 'N5KDI4HLYH',
                              final_value: 50.0 } }

      headers = { 'Content-Type': 'application/json' }

      charge_response = double('charge_response', status: 201, body: {}.to_json)
      allow(Faraday).to receive(:post).with(charge_url, parametro.to_json, headers).and_return(charge_response)

      checkout_json = Rails.root.join('spec/support/json/awaiting_payment.json').read
      order_code = JSON.parse(checkout_json)[0]['order_code']
      checkout_url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{order_code}/awaiting_payment"
      checkout_response = double('charge_response', status: 200, body: checkout_json)
      allow(Faraday).to receive(:post).with(checkout_url).and_return(checkout_response)

      pending_orders_reloaded_json = Rails.root.join('spec/support/json/pending_orders_reloaded.json').read
      pending_orders_reloaded_response = double('faraday_response_2', status: 200, body: pending_orders_reloaded_json)
      pending_orders_url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
      allow(Faraday).to receive(:get).with(pending_orders_url).and_return(pending_orders_reloaded_response)

      login_as(user)
      visit(orders_path)
      visit(checkout_order_path(2))
      select '[Visa] **** **** **** 9811', from: 'Selecionar Cartão:'
      fill_in 'Número de Parcelas:', with: '3'
      click_on('Confirmar')

      expect(current_path).to eq orders_path
      expect(page).to have_content('Pedido de Pagamento enviado com Sucesso!')
      within('table tr:nth-child(2)') do
        expect(page).to have_content('Plano Prata')
        expect(page).to have_content('N5KDI4HLYH')
        expect(page).to have_content('Aguardando pagamento')
        expect(page).to have_content('R$ 50,00')
        expect(page).not_to have_button('Cancelar')
        expect(page).not_to have_link('Pagar')
      end
    end

    it 'não consegue efetuar uma requisição de pagamento' do
      user = create(:user, identification: 62_429_965_704)
      create(:credit_card, user:)
      create(:credit_card, token: 'kh45234vb234m', card_number: '9811', credit_card_flag: 'Visa', user:)

      pending_orders_json = Rails.root.join('spec/support/json/pending_orders.json').read
      response = double('faraday_response', status: 200, body: pending_orders_json)
      checkout_url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
      allow(Faraday).to receive(:get).with(checkout_url).and_return(response)

      charge_url = "#{ENV.fetch('BASE_URL_CHARGES')}/charges"

      parametro = { charge: { creditcard_token: 'kh45234vb234m',
                              client_cpf: '62429965704',
                              order: 'N5KDI4HLYH',
                              final_value: 50.0 } }

      headers = { 'Content-Type': 'application/json' }

      charge_response = double('charge_response', status: 400, body: {}.to_json)
      allow(Faraday).to receive(:post).with(charge_url, parametro.to_json, headers).and_return(charge_response)

      login_as(user)
      visit(orders_path)
      within('table tr:nth-child(2)') do
        click_on('Pagar')
      end
      select '[Visa] **** **** **** 9811', from: 'Selecionar Cartão:'
      fill_in 'Número de Parcelas:', with: '3'
      click_on('Confirmar')

      expect(current_path).to eq orders_path
      expect(page).to have_content('Pagamento não foi aceito, revise os dados e tente novamente!')
      within('table tr:nth-child(2)') do
        expect(page).to have_content('Plano Prata')
        expect(page).to have_content('R$ 50,00')
        expect(page).to have_content('N5KDI4HLYH')
        expect(page).to have_link('Pagar')
        expect(page).to have_button('Cancelar')
      end
    end
  end
end
