require 'rails_helper'

describe 'Usuário vê detalhes de um produto' do
  it 'e não esta logado' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    price = create(:price, price: 7.99, plan:, periodicity:, status: :active)

    visit price_path(price)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'e vê informações adicionais' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    price = create(:price, price: 7.99, plan:, periodicity:, status: :active)
    Price.update(status: :active)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    link_to_show.click

    expect(current_path).to eq price_path(price)
    expect(page).to have_content('Ativo')
    expect(page).to have_content('Hospedagem (HPPRO) / Hospedagem de Site')
    expect(page).to have_content('Mensal')
    expect(page).to have_content('1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis')
    expect(page).to have_content('1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    expect(page).to have_content('R$ 7,99')
  end

  it 'e voltar para a tela inicial' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    create(:price, price: 7.99, plan:, periodicity:, status: :active)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    link_to_show.click
    click_on 'Voltar'

    expect(current_path).to eq prices_path
  end
end
