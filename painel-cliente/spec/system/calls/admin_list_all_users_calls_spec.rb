require 'rails_helper'

describe 'Administrador lista chamados de todos os clientes' do
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

  context 'autenticado como administrador' do
    it 'consegue acessar o menu chamados' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)

      login_as(user)
      visit root_path

      expect(page).to have_content 'Chamados'
    end

    it 'e não existem chamados' do
      user = create(:user, identification: 23_318_591_084, role: :administrator)

      login_as(user)
      visit root_path
      click_on 'Chamados'

      expect(page).to have_content 'Chamados'
      expect(page).to have_content 'Não existem chamados'
    end

    it 'visualiza os chamados de todos clientes, ordenando estes em ordem alfabética' do
      user1 = create(:user, name: 'Jose da Silva', identification: 23_318_591_084, role: :client)
      user2 = create(:user, name: 'Maria do Socorro', identification: 55_149_912_026, role: :client)
      user3 = create(:user, name: 'João Andrade', identification: 62_429_965_704, role: :administrator)

      category1 = create(:call_category, description: 'Financeiro')
      category2 = create(:call_category, description: 'Suporte Técnico')
      category3 = create(:call_category, description: 'Sugestões')
      category4 = create(:call_category, description: 'Reclamações')

      product1 = create(:product, user: user1, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')
      product2 = create(:product, user: user1, order_code: 'ABC456', product_plan_name: 'Plano Cloud')
      product3 = create(:product, user: user2, order_code: 'ABC789', product_plan_name: 'Plano Email Marketing')
      product4 = create(:product, user: user2, order_code: 'ABC321', product_plan_name: 'Plano Hospedagem II')

      travel_to Time.zone.local(2023, 2, 15, 12, 0, 0) do
        allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('XYZ123')
        create(:call, subject: 'Host configurado incorretamente',
                      description: 'O host está com nome de domínio errado',
                      status: :open,
                      user: user2,
                      product: product1,
                      call_category: category1)

        allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('XYZ789')
        create(:call, subject: 'Tamanho de armazenamento insuficiente',
                      description: 'Por favor, aumentar o tamanho de armazenamento',
                      status: :open,
                      user: user1,
                      product: product2,
                      call_category: category2)
      end
      travel_to Time.zone.local(2023, 2, 15, 12, 0, 0) do
        allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('XYZ321')
        create(:call, subject: 'Não consigo enviar e-mails',
                      description: 'Estou tentando enviar emails mas não consigo',
                      status: :open,
                      user: user2,
                      product: product3,
                      call_category: category3)

        allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('XYZ987')
        create(:call, subject: 'Não consigo acessar o painel de controle',
                      description: 'Preciso utilizar o painel de controle para configurar o host',
                      status: :open,
                      user: user1,
                      product: product4,
                      call_category: category4)
      end

      login_as(user3)
      visit root_path
      click_on 'Chamados'

      expect(current_path).to eq calls_path
      expect(page).to have_content 'Chamados'
      within('table thead tr') do
        expect(page).to have_content 'Data'
        expect(page).to have_content 'Cliente'
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Assunto'
        expect(page).to have_content 'Produto'
        expect(page).to have_content 'Categoria'
        expect(page).to have_content 'Status'
      end
      within('table tbody tr:nth-child(1)') do
        expect(page).to have_content '15/02/2023'
        expect(page).to have_content 'Jose da Silva'
        expect(page).to have_content 'XYZ789'
        expect(page).to have_content 'Tamanho de armazenamento insuficiente'
        expect(page).to have_content 'Plano Cloud'
        expect(page).to have_content 'Suporte Técnico'
        expect(page).to have_content 'Aberto'
        expect(page).to have_link 'Encerrar'
      end
      within('table tbody tr:nth-child(2)') do
        expect(page).to have_content '15/02/2023'
        expect(page).to have_content 'Jose da Silva'
        expect(page).to have_content 'XYZ987'
        expect(page).to have_content 'Não consigo acessar o painel de controle'
        expect(page).to have_content 'Plano Hospedagem II'
        expect(page).to have_content 'Reclamações'
        expect(page).to have_content 'Aberto'
        expect(page).to have_link 'Encerrar'
      end
      within('table tbody tr:nth-child(3)') do
        expect(page).to have_content '15/02/2023'
        expect(page).to have_content 'Maria do Socorro'
        expect(page).to have_content 'XYZ123'
        expect(page).to have_content 'Host configurado incorretamente'
        expect(page).to have_content 'Plano Hospedagem I'
        expect(page).to have_content 'Financeiro'
        expect(page).to have_content 'Aberto'
        expect(page).to have_link 'Encerrar'
      end
      within('table tbody tr:nth-child(4)') do
        expect(page).to have_content '15/02/2023'
        expect(page).to have_content 'Maria do Socorro'
        expect(page).to have_content 'XYZ321'
        expect(page).to have_content 'Não consigo enviar e-mails'
        expect(page).to have_content 'Plano Email Marketing'
        expect(page).to have_content 'Sugestões'
        expect(page).to have_content 'Aberto'
        expect(page).to have_link 'Encerrar'
      end
    end
  end
end
