require 'rails_helper'

describe 'usuario edita um plano a partir da página inicial' do
  it 'e não esta logado' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: 5)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: 'active',
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')

    visit edit_plan_path(plan)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'com sucesso' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                  description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                  details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')

    login
    visit root_path
    click_on 'Planos'
    link_to_edit.click
    within('#create_plan') do
      fill_in 'Nome', with: 'Hospedagem Pró'
      select 'Descontinuado', from: 'Status'
      click_on 'Salvar'
    end

    expect(current_path).to eq plans_path
    expect(page).to have_content 'Hospedagem Pró'
    expect(page).to have_content 'Descontinuado'
    expect(page).not_to have_content 'Hospedagem Básica'
    expect(page).not_to have_content 'Salvar'
  end

  it 'e deixa campos obrigatórios em branco' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                  description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                  details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')

    login
    visit root_path
    click_on 'Planos'
    link_to_edit.click
    within('#create_plan') do
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Detalhes', with: ''
      select 'Descontinuado', from: 'Status'
      click_on 'Salvar'
    end

    expect(page).to have_content 'Não foi possível atualizar plano.'
    expect(page).not_to have_content 'Plano cadastrado com sucesso.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Detalhes não pode ficar em branco'
  end

  it 'e cancela a operação' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSP', status: :active)
    create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                  description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                  details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')

    login
    visit root_path
    click_on 'Planos'
    link_to_edit.click
    within('#create_plan') do
      fill_in 'Nome', with: 'Hospedagem Pró'
      select 'Descontinuado', from: 'Status'
      click_on 'Cancelar'
    end

    expect(current_path).to eq plans_path
    expect(page).to have_content 'Cadastrar novo'
    expect(page).not_to have_button 'Salvar'
    expect(page).not_to have_link 'Cancelar'
  end
end
