require 'rails_helper'

describe 'Usuário vai para página de detalhes de um pedido pendente estando' do
  context 'não autenticado' do
    it 'e é redirecionado para a tela de login' do
      visit orders_path

      expect(current_path).to eq new_user_session_path
    end
  end
  context 'autenticado como cliente' do
    it 'e vê informações adicionais' do
      user = create(:user)
      json = Rails.root.join('spec/support/json/pending_orders.json').read
      response = double('faraday_response', status: 200, body: json)
      url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
      allow(Faraday).to receive(:get).with(url).and_return(response)

      login_as(user)
      visit(orders_path)
      within('table tbody tr:nth-child(1)') do
        click_on('Plano Bronze')
      end
      expect(page).to have_content('Informações sobre o pedido: Plano Bronze')
      expect(page).to have_content('Pedido: KRR4JOLSRG')
      expect(page).to have_content('Plano: Plano Bronze')
      expect(page).to have_content('Valor: R$ 30,00')
      expect(page).to have_content('Periodicidade: Mensal')
      expect(page).to have_content('Desconto: 0.0%')
      expect(page).to have_content('Meio de pagamento: ')
      expect(page).to have_content('Status: Pendente')
    end
    it 'e volta para a tela inicial' do
      user = create(:user)
      json = Rails.root.join('spec/support/json/pending_orders.json').read
      response = double('faraday_response', status: 200, body: json)
      url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
      allow(Faraday).to receive(:get).with(url).and_return(response)

      login_as(user)
      visit(orders_path)
      click_on('Plano Prata')
      click_on('Voltar')

      expect(current_path).to eq(orders_path)
    end
  end
end
