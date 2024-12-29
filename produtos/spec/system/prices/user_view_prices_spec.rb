require 'rails_helper'

describe 'Usuário vê preços' do
  it 'e não esta logado' do
    visit prices_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'do menu de navegação' do
    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')

    expect(page).to have_content('Preços')
    expect(page).to have_link('Cadastrar novo')
  end

  it 'e vê os preços cadastrados' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity_a = create(:periodicity, name: 'Mensal', deadline: 1)
    periodicity_b = create(:periodicity, name: 'Trimestral', deadline: 3)
    create(:price, price: 7.99, plan:, periodicity: periodicity_a, status: :active)
    create(:price, price: 19.99, plan:, periodicity: periodicity_b, status: :active)
    Price.update(status: :active)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')

    expect(page).not_to have_content 'Não há Preços cadastrados.'
    within '#price_1' do
      expect(page).to have_content('Hospedagem de Site')
      expect(page).to have_content('Mensal')
      expect(page).to have_content('R$ 7,99')
      expect(page).to have_content 'Ativo'
    end
    within '#price_2' do
      expect(page).to have_content('Hospedagem de Site')
      expect(page).to have_content('Trimestral')
      expect(page).to have_content('R$ 19,9')
      expect(page).to have_content 'Ativo'
    end
  end

  it 'e não existem preços cadastrados' do
    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')

    expect(current_path).to eq prices_path
    expect(page).to have_content('Não há Preços cadastrados.')
  end
end
