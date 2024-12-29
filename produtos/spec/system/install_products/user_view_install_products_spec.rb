require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'do menu de navegação' do
    login
    visit root_path
    click_on('Instalações de Produtos')

    expect(page).to have_content('Instalações')
    expect(page).not_to have_link('Cadastrar novo')
  end

  it 'e não esta logado' do
    visit install_products_path
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'e vê instalações dos produtos' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site',
                                           code: 'HOSPE', status: 5)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
    server = create(:server, operational_system: :windows, os_version: '10.3.7',
                             number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32,
                             max_installations: 50, product_group:, type_of_storage: :ssd)
    create(:install_product, customer_document: '620.713.365-31', order_code: 'XYZ123', server:)

    login
    visit root_path
    click_on('Instalações de Produtos')

    expect(page).to have_content 'Ativo'
    expect(page).to have_content 'WINDO-HOSPE-ABCD1234'
    expect(page).to have_content '620.713.365-31'
    expect(page).to have_content 'XYZ123'
  end

  it 'e não existem instalações cadastradas' do
    login
    visit root_path
    click_on('Instalações de Produtos')

    expect(page).to have_content 'Não há Instalações cadastradas.'
  end
end
