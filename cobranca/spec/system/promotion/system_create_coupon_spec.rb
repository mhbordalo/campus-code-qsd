require 'rails_helper'

describe 'após criada a promoção o sistema irá' do
  context 'gerar os cupons' do
    it 'e mostrar na tela' do
      User.create!(email: 'admin@locaweb.com.br', password: '12345678')
      user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
      json_data = Rails.root.join('spec/support/json/products.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/product_groups/').and_return(fake_response)
      create(:promotion, user_create: 1, coupon_quantity: 14)

      visit root_path
      login_as(user)
      click_on 'Listar Promoções'
      click_on 'Detalhes da promoção'
      click_on 'Aprovar promoção'

      expect(page).to have_content 'Promoção aprovada com sucesso.'
      expect(page).to have_content "Aprovado por: #{user.email}"
      expect(page).to have_content 'Status Ativada'

      expect(page).to have_content 'Cupons da promoção'
      expect(page).to have_content 'Quantidade de Cupons: 14'
    end

    it 'mostrar coupons utilizado' do
      User.create!(email: 'admin@locaweb.com.br', password: '12345678')
      user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
      json_data = Rails.root.join('spec/support/json/products.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/product_groups/').and_return(fake_response)
      create(:promotion, name: 'Promotion Created', user_create: 1, coupon_quantity: 3, status: :activated)
      create(:coupon, promotion_id: 1, status: 0)
      create(:coupon, promotion_id: 1, status: 0)
      create(:coupon, promotion_id: 1, status: 3)

      visit root_path
      login_as(user)
      click_on 'Listar Promoções'
      click_on 'Promotion Created'

      expect(page).to have_content 'Status Ativada'
      expect(page).to have_content 'Cupons da promoção'
      expect(page).to have_content 'Quantidade de Cupons: 3'
      expect(page).to have_content 'Disponível', count: 2
      expect(page).to have_content 'Utilizado', count: 1
    end
  end
end
