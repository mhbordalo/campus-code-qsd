require 'rails_helper'
describe 'Product API' do
  context 'POST /api/v1/product/{order_code}/uninstall' do
    it 'com sucesso' do
      user = create(:user, identification: 23_318_591_084)
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1', installation: :installed)
      create(:product, user:, order_code: 'ABC456', product_plan_name: 'Plano 1', installation: :installed)

      login_as user

      post "/api/v1/product/#{product.order_code}/uninstalled"

      expect(response.status).to eq 204
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content 'Não instalado'
      end
    end

    it 'com erro de produto não encontrado' do
      user = create(:user, identification: 23_318_591_084)
      create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1', installation: :installed)
      create(:product, user:, order_code: 'ABC456', product_plan_name: 'Plano 1', installation: :installed)

      login_as user

      post '/api/v1/product/ABC124/uninstalled'

      expect(response.status).to eq 404
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content 'Instalado'
      end
    end
  end
end
