require 'rails_helper'

describe 'usuario cadastra um novo plano' do
  it 'e não esta logado' do
    visit new_plan_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'a partir da página inicial' do
    login
    visit root_path
    click_on 'Planos'
    click_on 'Cadastrar novo'

    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Detalhes'
    expect(page).to have_field 'Grupo de Produtos'
    expect(page).to have_field 'Status'
    expect(page).to have_button 'Salvar'
    expect(page).to have_link 'Cancelar'
  end

  it 'com sucesso' do
    ProductGroup.create(name: 'Hospedagem', description: 'Hospedagem de Site',
                        code: 'HOSPE', status: :active)

    login
    visit root_path
    click_on 'Planos'
    click_on 'Cadastrar novo'
    within('#create_plan') do
      fill_in 'Nome', with: 'Hospedagem Básica'
      fill_in 'Descrição', with: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis'
      select 'Hospedagem', from: 'Grupo de Produtos'
      fill_in 'Detalhes', with: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada'
      select 'Ativo', from: 'Status'
      click_on 'Salvar'
    end

    expect(current_path).to eq plans_path
    expect(page).to have_content 'Plano cadastrado com sucesso.'
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_content '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis'
    expect(page).not_to have_content 'Salvar'
  end

  it 'e deixa campo obrigatório em branco' do
    grupo = ProductGroup.create(name: 'Hospedagem', description: 'Hospedagem de Site', code: 'HOSPE', status: :active)

    login
    visit root_path
    click_on 'Planos'
    click_on 'Cadastrar novo'
    within('#create_plan') do
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      select grupo.name, from: 'Grupo de Produtos'
      fill_in 'Detalhes', with: ''
      select 'Ativo', from: 'Status'
      click_on 'Salvar'
    end

    expect(page).to have_content 'Não foi possível cadastrar plano.'
    expect(page).not_to have_content 'Plano cadastrado com sucesso.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Detalhes não pode ficar em branco'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Detalhes'
  end

  it 'e cancela a operação' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    login
    visit root_path
    click_on 'Planos'
    click_on 'Cadastrar novo'
    fill_in 'Nome', with: 'Hospedagem Básica'
    fill_in 'Descrição', with: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis'
    select product_group.name, from: 'Grupo de Produtos'
    fill_in 'Detalhes', with: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada'
    select 'Ativo', from: 'Status'
    click_on 'Cancelar'

    expect(current_path).to eq plans_path
    expect(page).to have_content 'Não há Planos cadastrados'
    expect(page).not_to have_content 'Plano cadastrado com sucesso'
  end
end
