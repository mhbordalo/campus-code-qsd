require 'rails_helper'

describe 'Usuário vê detalhes de um servidor' do
  it 'e não esta logado' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    server = create(:server, operational_system: :windows, os_version: '10.3.7',
                             number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                             product_group:, type_of_storage: :ssd)

    visit server_path(server)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'e vê informações adicionais' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
    server = create(:server, operational_system: :windows, os_version: '10.3.7',
                             number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 4096, max_installations: 50,
                             product_group:, type_of_storage: :ssd)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    all(:css, '.ls-tooltip-top-left')[0].click

    expect(current_path).to eq server_path(server)
    expect(page).to have_content('WINDO-HPPRO-ABCD1234')
    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('Windows')
    expect(page).to have_content('10.3.7')
    expect(page).to have_content('32')
    expect(page).to have_content('2048 GB')
    expect(page).to have_content('4096 MB')
    expect(page).to have_content('50')
    expect(page).to have_content('SSD')
  end

  it 'e voltar para a tela inicial' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    create(:server, operational_system: :windows, os_version: '10.3.7',
                    number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 4096, max_installations: 50,
                    product_group:, type_of_storage: :ssd)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    all(:css, '.ls-tooltip-top-left')[0].click
    click_on 'Voltar'

    expect(current_path).to eq servers_path
  end
end
