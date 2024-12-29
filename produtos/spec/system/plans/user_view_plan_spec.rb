require 'rails_helper'

describe 'Usuário vê lista de planos a partir da página inicial' do
  it 'e não esta logado' do
    visit plans_path

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

    expect(current_path).to eq plans_path
    expect(page).to have_content 'Cadastrar novo'
    expect(page).to have_content 'Hospedagem Básica'
    expect(page).to have_content '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis'
    expect(page).to have_content 'Ativo'
    expect(page).not_to have_content 'Não há Planos cadastrados.'
    expect(page).not_to have_content 'Salvar'
  end

  it 'e não existe planos cadastrados' do
    login
    visit root_path
    click_on 'Planos'

    expect(current_path).to eq plans_path
    expect(page).to have_content 'Cadastrar novo'
    expect(page).to have_content 'Não há Planos cadastrados.'
    expect(page).not_to have_content 'Salvar'
  end
end
