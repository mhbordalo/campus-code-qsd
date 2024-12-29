require 'rails_helper'

describe 'usuario cadastra um novo servidor' do
  it 'e não esta logado' do
    visit new_server_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'a partir da tela inicial do aplicativo' do
    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    click_on 'Cadastrar novo'

    expect(page).to have_select 'Sistema operacional'
    expect(page).to have_field 'Versão do sistema operacional'
    expect(page).to have_select 'Grupo de produto'
    expect(page).to have_field 'Quantidade de CPUs'
    expect(page).to have_field 'Capacidade de armazenamento'
    expect(page).to have_select 'Tipo de armazenamento'
    expect(page).to have_field 'Quantidade RAM'
    expect(page).to have_field 'Máximo de instalações'
  end

  it 'com sucesso' do
    create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site', code: 'HOSPE', status: 5)
    create(:product_group, name: 'Email', description: 'Servidor de e-mail', code: 'EMAIL', status: 5)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    click_on 'Cadastrar novo'
    select 'Hospedagem', from: 'Grupo de produto'
    select 'Linux', from: 'Sistema operacional'
    fill_in 'Versão do sistema operacional', with: 'Ubuntu 22.04 LTS'
    fill_in 'Quantidade de CPUs', with: '32'
    fill_in 'Quantidade RAM', with: '4096'
    fill_in 'Capacidade de armazenamento', with: '6144'
    select 'SSD', from: 'Tipo de armazenamento'
    fill_in 'Máximo de instalações', with: '50'
    click_on 'Salvar'

    expect(current_path).to eq servers_path
    expect(page).to have_content 'LINUX-HOSPE-ABCD1234'
    expect(page).to have_content 'Linux'
    expect(page).to have_content 'Hospedagem'
    expect(page).to have_content '6144 GB'
    expect(page).not_to have_content 'E-mail'
  end

  it 'e deixa campo obrigatório em branco' do
    create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site', code: 'HOSPE', status: 5)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    click_on 'Cadastrar novo'
    select 'Hospedagem', from: 'Grupo de produto'
    select 'Linux', from: 'Sistema operacional'
    fill_in 'Quantidade de CPUs', with: ''
    fill_in 'Quantidade RAM', with: ''
    fill_in 'Capacidade de armazenamento', with: ''
    select 'SSD', from: 'Tipo de armazenamento'
    fill_in 'Máximo de instalações', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível cadastrar servidor.'
    expect(page).not_to have_content 'Servidor cadastrado com sucesso.'
    expect(page).to have_content 'Quantidade de CPUs não pode ficar em branco'
    expect(page).to have_content 'Quantidade RAM não pode ficar em branco'
    expect(page).to have_content 'Capacidade de armazenamento não pode ficar em branco'
    expect(page).to have_content 'Máximo de instalações não pode ficar em branco'
    expect(page).to have_select 'Grupo de produto'
    expect(page).to have_content 'Hospedagem'
    expect(page).to have_field 'Quantidade de CPUs'
  end

  it 'e cancela a operação' do
    create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site', code: 'HOSPE', status: 5)

    login
    visit root_path
    find('nav.ls-menu').click_on('Servidores')
    click_on 'Cadastrar novo'
    select 'Hospedagem', from: 'Grupo de produto'
    select 'Linux', from: 'Sistema operacional'
    fill_in 'Versão do sistema operacional', with: 'Ubuntu 22.04 LTS'
    fill_in 'Quantidade de CPUs', with: '32'
    fill_in 'Quantidade RAM', with: '4096'
    fill_in 'Capacidade de armazenamento', with: '6144'
    select 'SSD', from: 'Tipo de armazenamento'
    fill_in 'Máximo de instalações', with: '50'
    click_on 'Cancelar'

    expect(current_path).to eq servers_path
    expect(page).to have_content('Não há Servidores cadastrados.')
    expect(page).not_to have_content 'Não foi possível cadastrar servidor.'
    expect(page).not_to have_content 'Servidor cadastrado com sucesso.'
    expect(page).not_to have_content 'Hospedagem'
  end
end
