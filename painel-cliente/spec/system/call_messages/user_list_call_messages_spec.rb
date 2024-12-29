require 'rails_helper'

describe 'Usuário lista mensagens do chamado' do
  context 'não autenticado' do
    it 'redireciona para login se acessar diretamente' do
      visit call_path(1)

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end
  context 'autenticado como cliente' do
    it 'consegue visualizar as mensagens do chamado com sucesso' do
      user1 = create(:user, identification: 23_318_591_084, role: :client)
      user2 = create(:user, identification: 62_429_965_704, role: :administrator)
      category = create(:call_category, description: 'Financeiro')
      product = create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano 1')
      call = create(:call, subject: 'Host com configurado incorretamente',
                           description: 'O host está com nome de domínio errado',
                           status: :open,
                           user_id: user1.id,
                           product_id: product.id,
                           call_category_id: category.id)

      create(:call_message, message: 'Mensagem 1', call_id: call.id, user_id: user1.id)
      create(:call_message, message: 'Resposta 1', call_id: call.id, user_id: user2.id)
      create(:call_message, message: 'Mensagem 2', call_id: call.id, user_id: user1.id)
      create(:call_message, message: 'Resposta 2', call_id: call.id, user_id: user2.id)

      login_as(user1)
      visit root_path
      click_on 'Chamados'
      click_on 'Host com configurado incorretamente'

      expect(current_path).to eq call_path(1)
      expect(page).to have_content 'Mensagem 1'
      expect(page).to have_content 'Resposta 1'
      expect(page).to have_content 'Mensagem 2'
      expect(page).to have_content 'Resposta 2'
    end
  end
end
