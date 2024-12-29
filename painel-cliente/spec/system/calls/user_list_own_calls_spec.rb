require 'rails_helper'

describe 'Usuário lista próprios chamados' do
  context 'não autenticado' do
    it 'não consegue acessar os chamados' do
      visit root_path

      expect(page).not_to have_content('Chamados')
    end

    it 'redireciona para login se acessar diretamente' do
      visit calls_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Para continuar, efetue login ou registre-se.')
    end
  end

  context 'autenticado como cliente' do
    it 'consegue acessar o menu chamados' do
      user1 = create(:user, identification: 23_318_591_084, role: :client)
      user2 = create(:user, identification: 55_149_912_026, role: :client)
      category1 = create(:call_category, description: 'Financeiro')
      category2 = create(:call_category, description: 'Suporte Técnico')
      create(:call_category, description: 'Sugestões')
      create(:call_category, description: 'Reclamações')
      product1 = create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      product2 = create(:product, user: user1, order_code: 'ABC456', product_plan_name: 'Plano Cloud')
      product3 = create(:product, user: user2, order_code: 'ABC789', product_plan_name: 'Plano Email Marketing')
      product4 = create(:product, user: user2, order_code: 'ABC321', product_plan_name: 'Plano Hospedagem II')

      create(:call, call_code: 'XYZ123',
                    subject: 'Host com configurado incorretamente',
                    description: 'O host está com nome de domínio errado',
                    status: :open,
                    user_id: user1.id,
                    product_id: product1.id,
                    call_category_id: category1.id)

      create(:call, call_code: 'XYZ789',
                    subject: 'Tamanho de armazenamento insuficiente',
                    description: 'Por favor, aumentar o tamanho de armazenamento',
                    status: :open,
                    user_id: user1.id,
                    product_id: product2.id,
                    call_category_id: category2.id)

      create(:call, call_code: 'XYZ321',
                    subject: 'Não consigo enviar e-mails',
                    description: 'Estou tentando enviar emails mas não consigo',
                    status: :open,
                    user_id: user2.id,
                    product_id: product3.id,
                    call_category_id: category1.id)

      create(:call, call_code: 'XYZ456',
                    subject: 'Não consigo acessar o painel de controle',
                    description: 'Preciso utilizar o painel de controle para configurar o host',
                    status: :open,
                    user_id: user2.id,
                    product_id: product4.id,
                    call_category_id: category2.id)

      login_as(user1)
      visit root_path

      expect(page).to have_content 'Chamados'
    end

    it 'e não existem chamados' do
      user = create(:user, identification: 23_318_591_084, role: :client)

      login_as(user)
      visit root_path
      click_on 'Chamados'

      expect(page).to have_content 'Chamados'
      expect(page).to have_content 'Não existem chamados'
    end

    it 'visualiza seus próprios chamados' do
      user1 = create(:user, identification: 23_318_591_084, role: :client)
      user2 = create(:user, identification: 55_149_912_026, role: :client)
      category1 = create(:call_category, description: 'Financeiro')
      category2 = create(:call_category, description: 'Suporte Técnico')
      create(:call_category, description: 'Sugestões')
      create(:call_category, description: 'Reclamações')
      product1 = create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      product2 = create(:product, user: user1, order_code: 'ABC456', product_plan_name: 'Plano Cloud')
      product3 = create(:product, user: user2, order_code: 'ABC789', product_plan_name: 'Plano Email Marketing')
      product4 = create(:product, user: user2, order_code: 'ABC321', product_plan_name: 'Plano Hospedagem II')

      call1 = create(:call, call_code: 'XYZ123',
                            subject: 'Host com configurado incorretamente',
                            description: 'O host está com nome de domínio errado',
                            status: :open,
                            user_id: user1.id,
                            product_id: product1.id,
                            call_category_id: category1.id)

      call2 = create(:call, call_code: 'XYZ789',
                            subject: 'Tamanho de armazenamento insuficiente',
                            description: 'Por favor, aumentar o tamanho de armazenamento',
                            status: :open,
                            user_id: user1.id,
                            product_id: product2.id,
                            call_category_id: category2.id)

      create(:call, call_code: 'XYZ321',
                    subject: 'Não consigo enviar e-mails',
                    description: 'Estou tentando enviar emails mas não consigo',
                    status: :open,
                    user_id: user2.id,
                    product_id: product3.id,
                    call_category_id: category1.id)

      create(:call, call_code: 'XYZ456',
                    subject: 'Não consigo acessar o painel de controle',
                    description: 'Preciso utilizar o painel de controle para configurar o host',
                    status: :open,
                    user_id: user2.id,
                    product_id: product4.id,
                    call_category_id: category2.id)

      login_as(user1)
      visit root_path
      click_on 'Chamados'

      expect(current_path).to eq calls_path
      expect(page).to have_content 'Chamados'
      within('table thead tr') do
        expect(page).to have_content 'Data'
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Assunto'
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Categoria'
        expect(page).to have_content 'Status'
        expect(page).not_to have_content 'Cliente'
      end
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content I18n.l(call1.created_at, format: '%d/%m/%Y')
        expect(page).to have_content call1.call_code
        expect(page).to have_content 'Host com configurado incorretamente'
        expect(page).to have_content 'Plano Hospedagem I'
        expect(page).to have_content 'Financeiro'
        expect(page).to have_content 'Aberto'
        expect(page).to have_content 'Encerrar'
        expect(page).not_to have_content 'Jose da Silva'
      end

      within('table tbody tr:nth-child(2)') do
        expect(page).to have_content I18n.l(call2.created_at, format: '%d/%m/%Y')
        expect(page).to have_content call2.call_code
        expect(page).to have_content 'Tamanho de armazenamento insuficiente'
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'Suporte Técnico'
        expect(page).to have_content 'Aberto'
        expect(page).not_to have_content 'Jose da Silva'
      end
    end

    it 'não vê chamados de outros usuários' do
      user1 = create(:user, identification: 23_318_591_084, role: :client)
      user2 = create(:user, identification: 55_149_912_026, role: :client)
      category1 = create(:call_category, description: 'Financeiro')
      category2 = create(:call_category, description: 'Suporte Técnico')
      create(:call_category, description: 'Sugestões')
      create(:call_category, description: 'Reclamações')
      product1 = create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      product2 = create(:product, user: user1, order_code: 'ABC456', product_plan_name: 'Plano Cloud')
      product3 = create(:product, user: user2, order_code: 'ABC789', product_plan_name: 'Plano Email Marketing')
      product4 = create(:product, user: user2, order_code: 'ABC321', product_plan_name: 'Plano Hospedagem II')

      create(:call, call_code: 'XYZ123',
                    subject: 'Host com configurado incorretamente',
                    description: 'O host está com nome de domínio errado',
                    status: :open,
                    user_id: user1.id,
                    product_id: product1.id,
                    call_category_id: category1.id)

      create(:call, call_code: 'XYZ789',
                    subject: 'Tamanho de armazenamento insuficiente',
                    description: 'Por favor, aumentar o tamanho de armazenamento',
                    status: :open,
                    user_id: user1.id,
                    product_id: product2.id,
                    call_category_id: category2.id)

      create(:call, call_code: 'XYZ321',
                    subject: 'Não consigo enviar e-mails',
                    description: 'Estou tentando enviar emails mas não consigo',
                    status: :open,
                    user_id: user2.id,
                    product_id: product3.id,
                    call_category_id: category1.id)

      create(:call, call_code: 'XYZ456',
                    subject: 'Não consigo acessar o painel de controle',
                    description: 'Preciso utilizar o painel de controle para configurar o host',
                    status: :open,
                    user_id: user2.id,
                    product_id: product4.id,
                    call_category_id: category2.id)

      login_as(user1)
      visit root_path
      click_on 'Chamados'

      within('table') do
        expect(page).not_to have_content 'XYZ321'
        expect(page).not_to have_content 'Não consigo enviar e-mails'
        expect(page).not_to have_content 'Plano Email Marketing'
        expect(page).not_to have_content 'Sugestões'
        expect(page).not_to have_content 'XYZ456'
        expect(page).not_to have_content 'Não consigo acessar o painel de controle'
        expect(page).not_to have_content 'Plano Hospedagem II'
        expect(page).not_to have_content 'Reclamações'
      end
    end
  end
end
