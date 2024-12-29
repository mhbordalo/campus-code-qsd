require 'rails_helper'

describe 'usuario edita um preço' do
  it 'e não esta logado' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: 5)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: 'active',
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    price = create(:price, price: 7.99, plan:, periodicity:, status: 'active')

    visit edit_price_path(price)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'com sucesso' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    create(:price, price: 7.99, plan_id: plan.id, periodicity:, status: :active)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    link_to_edit.click
    fill_in 'Preço', with: '7.99'
    select 'Hospedagem Básica', from: 'Plano'
    select 'Mensal', from: 'Periodicidade'
    select 'Ativo', from: 'Status'
    click_on 'Salvar'

    expect(current_path).to eq prices_path
    expect(page).to have_content 'R$ 7,99'
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_content 'Mensal'
    expect(page).not_to have_content 'Salvar'
  end

  it 'e deixa campos obrigatórios em branco' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    create(:price, price: 7.99, plan_id: plan.id, periodicity:, status: :active)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    link_to_edit.click
    fill_in 'Preço', with: ''
    select 'Hospedagem Básica', from: 'Plano'
    select 'Mensal', from: 'Periodicidade'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível atualizar preço.'
    expect(page).not_to have_content 'Preço cadastrado com sucesso.'
    expect(page).to have_content 'Preço não pode ficar em branco'
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_content 'Mensal'
  end

  it 'e cancela a operação' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    create(:price, price: 7.99, plan:, periodicity:, status: :active)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    link_to_edit.click
    fill_in 'Preço', with: '9.99'
    select 'Hospedagem Básica', from: 'Plano'
    select 'Mensal', from: 'Periodicidade'
    click_on 'Cancelar'

    expect(current_path).to eq prices_path
    expect(page).to have_content 'R$ 7,99'
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_content 'Mensal'
  end
end
