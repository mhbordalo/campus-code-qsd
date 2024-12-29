require 'rails_helper'

describe 'Usuário cria mensagens do chamado' do
  context 'autenticado como cliente' do
    it 'consegue visualizar formulário de criar mensagens' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      create(:user, identification: 62_429_965_704, role: :administrator)
      category = create(:call_category, description: 'Financeiro')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')
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
      expect(page).to have_css 'div#message'
      expect(page).to have_button 'Enviar'
    end

    it 'consegue criar as mensagens do chamado com sucesso' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      create(:user, identification: 62_429_965_704, role: :administrator)
      category = create(:call_category, description: 'Financeiro')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')
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
      fill_in 'message', with: 'Mensagem 1 do chamado'
      click_on 'Enviar'

      expect(current_path).to eq call_path(1)
      expect(page).to have_content 'Mensagem 1 do chamado'
      expect(page).to have_css 'div#message'
      expect(page).to have_button 'Enviar'
    end

    it 'erro ao criar a mensagem do chamado' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      create(:user, identification: 62_429_965_704, role: :administrator)
      category = create(:call_category, description: 'Financeiro')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano 1')
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
      fill_in 'message', with: ''
      click_on 'Enviar'

      expect(current_path).to eq call_path(1)
      expect(page).to have_content 'Erro ao criar a mensagem do'
      expect(page).to have_css 'div#message'
      expect(page).to have_button 'Enviar'
    end
  end
end
