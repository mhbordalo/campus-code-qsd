require 'rails_helper'

describe 'Usuário vê servidores' do
  it 'do menu de navegação' do
    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')

    expect(page).to have_content('Servidores')
    expect(page).to have_link('Cadastrar novo')
  end

  it 'e vê os servidores cadastrados' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
    create(:server, operational_system: :windows, os_version: '10.3.7',
                    number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                    product_group:, type_of_storage: :ssd)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('EFGH5678')
    create(:server, operational_system: :linux, os_version: '22.04',
                    number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 16, max_installations: 150,
                    product_group:, type_of_storage: :ssd)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')

    expect(page).not_to have_content 'Não há Servidores cadastrados.'
    within '#server_1' do
      expect(page).to have_content('WINDO-HPPRO-ABCD1234')
      expect(page).to have_content('Windows')
      expect(page).to have_content('2048 GB')
    end
    within '#server_2' do
      expect(page).to have_content('LINUX-HPPRO-EFGH5678')
      expect(page).to have_content('Linux')
      expect(page).to have_content('8192 GB')
    end
  end

  it 'e não existem servidores cadastrados' do
    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')

    expect(current_path).to eq servers_path
    expect(page).to have_content('Não há Servidores cadastrados.')
  end
end
