require 'rails_helper'

describe 'Usuário vê detalhes de um plano cadastrado' do
  it 'e não esta logado ' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: 5)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: 'active',
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')

    visit plan_path(plan)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'a partir da página inicial com sucesso' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    plan = create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')

    login
    visit root_path
    click_on 'Planos'
    link_to_show.click

    expect(current_path).to eq plan_path(plan.id)
    expect(page).not_to have_content 'Cadastrar novo'
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_content '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis'
    expect(page).to have_content 'Ativo'
    expect(page).not_to have_content 'Não há Planos cadastrados.'
    expect(page).to have_content 'Voltar'
  end

  it 'e volta para a pagina inicial' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: :active)
    create(:plan, name: 'Hospedagem Básica', product_group:, status: :active,
                  description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                  details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')

    login
    visit root_path
    click_on 'Planos'
    link_to_show.click
    click_on 'Voltar'
    click_on 'Início'

    expect(current_path).to eq root_path
    expect(page).not_to have_button 'Cadastrar novo'
    expect(page).not_to have_button 'Voltar'
  end
end
