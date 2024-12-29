require 'rails_helper'

describe 'usuario edita um servidor' do
  it 'e não esta logado' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    server = create(:server, operational_system: :windows, os_version: '10.3.7',
                             number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                             product_group:, type_of_storage: :ssd)

    visit edit_server_path(server)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'a partir da tela inicial do aplicativo' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
    create(:server, operational_system: :windows, os_version: '10.3.7',
                    number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                    product_group:, type_of_storage: :ssd)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    all(:css, '.ls-tooltip-top-left')[1].click

    expect(page).to have_content('Servidor: WINDO-HPPRO-ABCD1234')
    expect(page).to have_select 'Sistema operacional', selected: 'Windows'
    expect(page).to have_field 'Versão do sistema operacional', with: '10.3.7'
    expect(page).to have_select 'Grupo de produto', selected: 'Hospedagem'
    expect(page).to have_field 'Quantidade de CPUs', with: '32'
    expect(page).to have_field 'Capacidade de armazenamento', with: '2048'
    expect(page).to have_select 'Tipo de armazenamento', selected: 'SSD'
    expect(page).to have_field 'Quantidade RAM', with: '32'
    expect(page).to have_field 'Máximo de instalações', with: '50'
  end

  it 'com sucesso' do
    group_a = create(:product_group, name: 'Hospedagem',
                                     description: 'Hospedagem sites',
                                     code: 'HPPRO')
    create(:product_group, name: 'E-mail Locaweb',
                           description: 'Tenha um e-mail profissional',
                           code: 'EMAIL')
    create(:server, operational_system: :windows, os_version: '10.3.7',
                    number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                    product_group: group_a, type_of_storage: :ssd)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    all(:css, '.ls-tooltip-top-left')[1].click
    select 'E-mail Locaweb', from: 'Grupo de produto'
    fill_in 'Versão do sistema operacional', with: 'Debian 11.7'
    fill_in 'Quantidade de CPUs', with: '64'
    fill_in 'Quantidade RAM', with: '2048'
    fill_in 'Capacidade de armazenamento', with: '8192'
    select 'HD', from: 'Tipo de armazenamento'
    fill_in 'Máximo de instalações', with: '180'
    click_on 'Salvar'

    expect(current_path).to eq servers_path
    expect(page).to have_content 'E-mail Locaweb'
    expect(page).to have_content '8192 GB'
    expect(page).not_to have_content 'Hospedagem'
    expect(page).not_to have_content 'Salvar'
  end

  it 'e deixa campos obrigatórios em branco' do
    group_a = create(:product_group, name: 'Hospedagem',
                                     description: 'Hospedagem sites',
                                     code: 'HPPRO')
    create(:product_group, name: 'E-mail Locaweb',
                           description: 'Tenha um e-mail profissional',
                           code: 'EMAIL')
    create(:server, code: 'WINDO-HSP-Q1W2E3R4', operational_system: :windows, os_version: '10.3.7',
                    number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                    product_group: group_a, type_of_storage: :ssd)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    all(:css, '.ls-tooltip-top-left')[1].click
    select 'E-mail Locaweb', from: 'Grupo de produto'
    fill_in 'Versão do sistema operacional', with: ''
    fill_in 'Quantidade de CPUs', with: ''
    fill_in 'Quantidade RAM', with: ''
    fill_in 'Capacidade de armazenamento', with: ''
    select 'HD', from: 'Tipo de armazenamento'
    fill_in 'Máximo de instalações', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível atualizar servidor.'
    expect(page).not_to have_content 'Servidor atualizado com sucesso.'
    expect(page).to have_content 'Quantidade de CPUs não pode ficar em branco'
    expect(page).to have_content 'Quantidade RAM não pode ficar em branco'
    expect(page).to have_content 'Capacidade de armazenamento não pode ficar em branco'
    expect(page).to have_content 'Máximo de instalações não pode ficar em branco'
    expect(page).to have_select 'Grupo de produto'
    expect(page).to have_content 'Hospedagem'
    expect(page).to have_field 'Quantidade de CPUs'
  end

  it 'e cancela a operação' do
    group_a = create(:product_group, name: 'Hospedagem',
                                     description: 'Hospedagem sites',
                                     code: 'HPPRO')
    create(:product_group, name: 'E-mail Locaweb',
                           description: 'Tenha um e-mail profissional',
                           code: 'EMAIL')
    create(:server, operational_system: :windows, os_version: '10.3.7',
                    number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                    product_group: group_a, type_of_storage: :ssd)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    all(:css, '.ls-tooltip-top-left')[1].click
    select 'E-mail Locaweb', from: 'Grupo de produto'
    fill_in 'Versão do sistema operacional', with: 'Debian 11.7'
    fill_in 'Quantidade de CPUs', with: '64'
    fill_in 'Quantidade RAM', with: '4096'
    fill_in 'Capacidade de armazenamento', with: '4096'
    select 'HD', from: 'Tipo de armazenamento'
    fill_in 'Máximo de instalações', with: '180'
    click_on 'Cancelar'

    expect(current_path).to eq servers_path
    expect(page).to have_content 'Hospedagem'
    expect(page).to have_content '2048 GB'
    expect(page).not_to have_content 'E-mail Locaweb'
  end
end
