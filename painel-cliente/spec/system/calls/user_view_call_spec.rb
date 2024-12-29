require 'rails_helper'

describe 'Usuário visualiza detalhes do chamado' do
  context 'não autenticado' do
    it 'redireciona para login se acessar diretamente' do
      visit call_path(1)
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'usuário autenticado' do
    it 'visualiza o chamado com sucesso' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      category = create(:call_category, description: 'Financeiro')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      create(:product, user:, order_code: 'ABC456', product_plan_name: 'Plano Cloud')
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('XYZ123')
      create(:call, subject: 'Host com configurado incorretamente',
                    description: 'O host está com nome de domínio errado',
                    status: :open,
                    user_id: user.id,
                    product_id: product.id,
                    call_category_id: category.id)

      login_as(user)
      visit root_path
      click_on 'Chamados'
      click_on 'Host com configurado incorretamente'

      expect(current_path).to eq call_path(1)
      expect(page).to have_content 'Chamado'

      within('div.call_details div:nth-child(1)') do
        expect(page).to have_content 'Status: Aberto'
      end
      within('div.call_details div:nth-child(2)') do
        expect(page).to have_content "Data de abertura: #{Time.zone.today.strftime('%d/%m/%Y')}"
      end
      within('div.call_details div:nth-child(3)') do
        expect(page).to have_content 'Produto - Pedido: Plano Hospedagem I - ABC123'
      end
      within('div.call_details div:nth-child(4)') do
        expect(page).to have_content 'Categoria: Financeiro'
      end
      within('div.call_details div:nth-child(5)') do
        expect(page).to have_content 'Assunto: Host com configurado incorretamente'
      end
      within('div.call_details div:nth-child(6)') do
        expect(page).to have_content 'Descrição: O host está com nome de domínio errado'
      end
    end
  end
end
