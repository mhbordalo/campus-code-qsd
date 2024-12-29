require 'rails_helper'

describe 'Usuário ' do
  context 'não autenticado' do
    it 'redirecionado para a tela de login' do
      visit orders_path

      expect(current_path).to eq new_user_session_path
    end
  end

  context 'autenticado como cliente' do
    it 'e vê estrutura da listagem de pedidos pendentes' do
      user = create(:user)
      json = Rails.root.join('spec/support/json/empty.json').read
      response = double('faraday_response', status: 404, body: json)
      url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
      allow(Faraday).to receive(:get).with(url).and_return(response)

      login_as(user)
      visit orders_path

      expect(page).to have_content 'Lista de Pedidos Pendentes'
      within('table') do
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'Preço'
        expect(page).to have_content 'Não existem pedidos pendentes cadastrados!'
      end
    end

    it 'e vê seus pedidos pendentes' do
      user = create(:user)
      json = Rails.root.join('spec/support/json/pending_orders.json').read
      response = double('faraday_response', status: 200, body: json)
      url = "#{ENV.fetch('BASE_URL_CHECKOUT')}/customers/#{user.identification}/orders"
      allow(Faraday).to receive(:get).with(url).and_return(response)

      login_as(user)
      visit orders_path

      within('table') do
        expect(page).to have_content 'Plano Bronze'
        expect(page).to have_content 'KRR4JOLSRG'
        expect(page).to have_content 'Pendente'
        expect(page).to have_content 'R$ 30,00'
        expect(page).to have_content 'Plano Prata'
        expect(page).to have_content 'N5KDI4HLYH'
        expect(page).to have_content 'Pendente'
        expect(page).to have_content 'R$ 50,00'
      end
    end
  end
end
