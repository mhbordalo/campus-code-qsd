require 'rails_helper'

describe 'Usuário atualiza o status do chamado' do
  context 'não autenticado' do
    it 'e é redirecionado para tela de login' do
      visit calls_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end
  context 'autenticado como cliente' do
    it 'e acessa a página para encerrar chamado' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      category = create(:call_category, description: 'Suporte Técnico')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')
      call = create(:call, subject: 'Host com configurado incorretamente',
                           description: 'O host está com nome de domínio errado',
                           status: :open,
                           user:,
                           product:,
                           call_category: category)

      login_as(user)
      visit root_path
      click_on 'Chamados'
      click_on 'Encerrar'
      expect(current_path).to eq close_call_path(call.id)
      expect(page).to have_content 'Encerrar Chamado XYZ123'
      expect(page).to have_content 'Assunto: Host com configurado incorretamente'
      expect(page).to have_content 'Descrição: O host está com nome de domínio errado'
      expect(page).to have_content 'Seu problema foi resolvido?'
      expect(page).to have_button 'Sim'
      expect(page).to have_button 'Não'
    end

    it 'e encerra o chamado com sucesso e o problema resolvido' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      category = create(:call_category, description: 'Suporte Técnico')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')

      create(:call, subject: 'Host com configurado incorretamente',
                    description: 'O host está com nome de domínio errado',
                    status: :open,
                    user:,
                    product:,
                    call_category: category)

      allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

      create(:call, subject: 'Minha caixa postal está cheia',
                    description: 'Como resolver o problema de caixa postal cheia?',
                    status: :open,
                    user:,
                    product:,
                    call_category: category)

      login_as(user)
      visit root_path
      click_on 'Chamados'
      within('table tbody tr:nth-child(2)') do
        click_on 'Encerrar'
      end

      expect(page).to have_content 'Encerrar Chamado XYZ123'
      click_on 'Sim'
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content 'Aberto'
        expect(page).to have_link 'Encerrar'
      end
      within('table tbody tr:nth-child(2)') do
        expect(page).to have_content 'Encerrado'
        expect(page).not_to have_link 'Encerrar'
      end
    end

    it 'e encerra o chamado com sucesso e o problema não foi resolvido' do
      user = create(:user, identification: 23_318_591_084, role: :client)
      category = create(:call_category, description: 'Suporte Técnico')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')

      create(:call, subject: 'Host com configurado incorretamente',
                    description: 'O host está com nome de domínio errado',
                    status: :open,
                    user:,
                    product:,
                    call_category: category)

      allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

      create(:call, subject: 'Minha caixa postal está cheia',
                    description: 'Como resolver o problema de caixa postal cheia?',
                    status: :open,
                    user:,
                    product:,
                    call_category: category)

      login_as(user)
      visit root_path
      click_on 'Chamados'
      within('table tbody tr:nth-child(2)') do
        click_on 'Encerrar'
      end

      expect(page).to have_content 'Encerrar Chamado XYZ123'
      click_on 'Não'
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content 'Aberto'
        expect(page).to have_link 'Encerrar'
      end
      within('table tbody tr:nth-child(2)') do
        expect(page).to have_content 'Encerrado com problemas'
        expect(page).not_to have_link 'Encerrar'
      end
    end
  end

  context 'autenticado como administrador' do
    it 'e acessa a página para encerrar chamado' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)
      category = create(:call_category, description: 'Suporte Técnico')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')

      allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

      call = create(:call, subject: 'Host com configurado incorretamente',
                           description: 'O host está com nome de domínio errado',
                           status: :open,
                           user:,
                           product:,
                           call_category: category)

      login_as(user)
      visit root_path
      click_on 'Chamados'
      click_on 'Encerrar'

      expect(current_path).to eq close_call_path(call.id)
      expect(page).to have_content 'Encerrar Chamado XYZ123'
      expect(page).to have_content 'Assunto: Host com configurado incorretamente'
      expect(page).to have_content 'Descrição: O host está com nome de domínio errado'
      expect(page).to have_content 'Seu problema foi resolvido?'
      expect(page).to have_button 'Sim'
      expect(page).to have_button 'Não'
    end

    it 'e encerra o chamado com sucesso e o problema resolvido' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)
      category = create(:call_category, description: 'Suporte Técnico')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')

      create(:call, subject: 'Host com configurado incorretamente',
                    description: 'O host está com nome de domínio errado',
                    status: :open,
                    user:,
                    product:,
                    call_category: category)

      allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

      create(:call, subject: 'Minha caixa postal está cheia',
                    description: 'Como resolver o problema de caixa postal cheia?',
                    status: :open,
                    user:,
                    product:,
                    call_category: category)

      login_as(user)
      visit root_path
      click_on 'Chamados'
      within('table tbody tr:nth-child(2)') do
        click_on 'Encerrar'
      end

      expect(page).to have_content 'Encerrar Chamado XYZ123'
      click_on 'Sim'
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content 'Aberto'
        expect(page).to have_link 'Encerrar'
      end
      within('table tbody tr:nth-child(2)') do
        expect(page).to have_content 'Encerrado'
        expect(page).not_to have_link 'Encerrar'
      end
    end

    it 'e encerra o chamado com sucesso e o problema não foi resolvido' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)
      category = create(:call_category, description: 'Suporte Técnico')
      product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')

      create(:call, subject: 'Host com configurado incorretamente',
                    description: 'O host está com nome de domínio errado',
                    status: :open,
                    user:,
                    product:,
                    call_category: category)

      allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

      create(:call, subject: 'Minha caixa postal está cheia',
                    description: 'Como resolver o problema de caixa postal cheia?',
                    status: :open,
                    user:,
                    product:,
                    call_category: category)

      login_as(user)
      visit root_path
      click_on 'Chamados'
      within('table tbody tr:nth-child(2)') do
        click_on 'Encerrar'
      end

      expect(page).to have_content 'Encerrar Chamado XYZ123'
      click_on 'Não'
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content 'Aberto'
        expect(page).to have_link 'Encerrar'
      end
      within('table tbody tr:nth-child(2)') do
        expect(page).to have_content 'Encerrado com problemas'
        expect(page).not_to have_link 'Encerrar'
      end
    end
  end
end
