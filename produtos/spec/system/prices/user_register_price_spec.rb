require 'rails_helper'

describe 'usuario cadastra um novo preço' do
  it 'e não esta logado' do
    visit new_price_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'a partir da tela inicial do aplicativo' do
    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    click_on 'Cadastrar novo'

    expect(page).to have_select 'Plano'
    expect(page).to have_select 'Periodicidade'
    expect(page).to have_field 'Preço'
    expect(page).to have_field 'Status'
  end

  it 'com sucesso' do
    grupo = ProductGroup.create!(name: 'Hospedagem', description: 'Hospedagem de Site', code: 'HOSPE', status: :active)
    plan = Plan.create!(name: 'Hospedagem Básica', product_group_id: grupo.id, status: :active,
                        description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                        details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = Periodicity.create!(name: 'Mensal', deadline: 1)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    click_on 'Cadastrar novo'
    select plan.name, from: 'Plano'
    select periodicity.name, from: 'Periodicidade'
    fill_in 'Preço', with: '12.99'
    select 'Ativo', from: 'Status'
    click_on 'Salvar'

    expect(current_path).to eq prices_path
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_content 'Mensal'
    expect(page).to have_content 'Ativo'
    expect(page).to have_content 'R$ 12,99'
  end

  it 'e deixa campo obrigatório em branco' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)

    login
    visit root_path
    click_on('Preços')
    click_on 'Cadastrar novo'
    select plan.name, from: 'Plano'
    select periodicity.name, from: 'Periodicidade'
    fill_in 'Preço', with: ''
    select 'Ativo', from: 'Status'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível cadastrar preço.'
    expect(page).not_to have_content 'Preço cadastrado com sucesso.'
    expect(page).to have_content 'Preço não pode ficar em branco'
    expect(page).to have_field 'Plano'
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_field 'Preço'
  end

  it 'e cancela a operação' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    click_on 'Cadastrar novo'
    select plan.name, from: 'Plano'
    select periodicity.name, from: 'Periodicidade'
    fill_in 'Preço', with: '49.99'
    select 'Ativo', from: 'Status'
    click_on 'Cancelar'

    expect(current_path).to eq prices_path
    expect(page).to have_content('Não há Preços cadastrados.')
    expect(page).not_to have_content 'Não foi possível cadastrar preço.'
    expect(page).not_to have_content 'Preço cadastrado com sucesso.'
    expect(page).not_to have_content 'Hospedagem Básica'
  end

  it 'e criar um novo preço, mas já existe um anterior ativo, a operação deverá inativar o preço antigo.' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    price = create(:price, price: 7.99, plan:, periodicity:, status: :active)

    login
    visit root_path
    find('nav.ls-menu').click_on('Preços')
    click_on 'Cadastrar novo'
    select plan.name, from: 'Plano'
    select periodicity.name, from: 'Periodicidade'
    fill_in 'Preço', with: '12.00'
    select 'Ativo', from: 'Status'
    click_on 'Salvar'

    expect(page).to have_content('Ativo')
    expect(price).not_to eq('Ativo')
  end
end
