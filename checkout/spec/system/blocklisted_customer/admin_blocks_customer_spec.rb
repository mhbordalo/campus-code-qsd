require 'rails_helper'

describe 'Admin blocks/unblocks customer' do
  it 'clicks on menu option with success' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

    login_as(admin)
    visit(root_path)
    click_on('Bloqueio de Clientes')

    expect(current_path).to eq(blocklisted_customers_path)
  end

  it 'User without admin priviledges cant see block users option on the menu' do
    user = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: false)

    login_as(user)
    visit(root_path)

    within('nav#main-menu') do
      expect(page).not_to have_content('Bloqueio de Clientes')
    end
  end

  it 'lists blocked customers as admin user' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    BlocklistedCustomer.create!(doc_ident: '18422142414', blocklisted_reason: 'Processo judicial em andamento.')
    BlocklistedCustomer.create!(doc_ident: '12341234123', blocklisted_reason: 'Divida')

    login_as(admin)
    visit(blocklisted_customers_path)

    expect(page).to have_content('18422142414')
    expect(page).to have_content('Processo judicial em andamento.')
    expect(page).to have_content('12341234123')
    expect(page).to have_content('Divida')
    within('tbody') do
      expect(page).to have_css('tr', count: 2)
    end
  end

  it 'unblocks a customer from the blocked list' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    BlocklistedCustomer.create!(doc_ident: '18422142414', blocklisted_reason: 'Processo judicial em andamento.')
    customer_to_block = BlocklistedCustomer.create!(doc_ident: '12341234123', blocklisted_reason: 'Divida')

    login_as(admin)
    visit(blocklisted_customers_path)
    within("#blocklisted_customer_#{customer_to_block.id}") do
      click_on 'Desbloquear'
    end

    expect(page).to have_content('18422142414')
    expect(page).to have_content('Processo judicial em andamento.')
    expect(page).not_to have_content('12341234123')
    expect(page).not_to have_content('Divida')
    within('tbody') do
      expect(page).to have_css('tr', count: 1)
    end
  end

  it 'searches for an existing customer to be blocked - external API call inside service' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    mocked_api_response = double({ status: 200,
                                   body: JSON.generate({
                                                         doc_ident: '12312312312',
                                                         name: 'José da Silva',
                                                         email: 'jose.silva@email.com.br',
                                                         address: 'Rua das Palmeiras, 100',
                                                         city: 'São Paulo',
                                                         state: 'SP',
                                                         zipcode: '11111-111',
                                                         phone: '11-99999-8888',
                                                         birthdate: '1980-01-01',
                                                         corporate_name: ''
                                                       }) })
    url = "#{Rails.configuration.external_apis['customer_api_url']}/12312312312"
    allow(Faraday).to receive(:get).with(url).and_return(mocked_api_response)

    login_as(admin)
    visit(blocklisted_customers_path)
    fill_in 'search_doc_ident', with: '12312312312'
    click_on 'Buscar'

    within('div#customer_details') do
      expect(page).to have_field('Nome:', with: 'José da Silva', disabled: true)
      expect(page).to have_field('Número do documento:', with: '12312312312', disabled: true)
      expect(page).to have_field('Razão para bloqueio:', count: 1)
    end
  end

  it 'blocks a customer after searching him' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    mocked_api_response = double({ status: 200,
                                   body: JSON.generate({
                                                         doc_ident: '12312312312',
                                                         name: 'José da Silva',
                                                         email: 'jose.silva@email.com.br',
                                                         address: 'Rua das Palmeiras, 100',
                                                         city: 'São Paulo',
                                                         state: 'SP',
                                                         zipcode: '11111-111',
                                                         phone: '11-99999-8888',
                                                         birthdate: '1980-01-01',
                                                         corporate_name: ''
                                                       }) })
    url = "#{Rails.configuration.external_apis['customer_api_url']}/12312312312"
    allow(Faraday).to receive(:get).with(url).and_return(mocked_api_response)

    login_as(admin)
    visit(blocklisted_customers_path)
    fill_in 'search_doc_ident', with: '12312312312'
    click_on 'Buscar'
    fill_in 'Razão para bloqueio:', with: 'Razão detalhada do bloqueio'
    click_on 'Bloquear'

    expect(page).to have_content('Cliente bloqueado com sucesso')
    within('tbody') do
      expect(page).to have_css('tr', count: 1)
      expect(page).to have_content('12312312312')
      expect(page).to have_content('Razão detalhada do bloqueio')
    end
  end

  it 'checks details of a customer already on the blocked list
      after clicking "ver detalhes" the list should only show the selected customer' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    blocked_customer = BlocklistedCustomer.create!(doc_ident: '12312312312',
                                                   blocklisted_reason: 'Processo judicial em andamento.')
    BlocklistedCustomer.create!(doc_ident: '12312312322', blocklisted_reason: 'Cliente 2 bloqueado.')
    mocked_api_response = double({ status: 200,
                                   body: JSON.generate({
                                                         doc_ident: '12312312312',
                                                         name: 'José da Silva',
                                                         email: 'jose.silva@email.com.br',
                                                         address: 'Rua das Palmeiras, 100',
                                                         city: 'São Paulo',
                                                         state: 'SP',
                                                         zipcode: '11111-111',
                                                         phone: '11-99999-8888',
                                                         birthdate: '1980-01-01',
                                                         corporate_name: ''
                                                       }) })
    url = "#{Rails.configuration.external_apis['customer_api_url']}/12312312312"
    allow(Faraday).to receive(:get).with(url).and_return(mocked_api_response)

    login_as(admin)
    visit(blocklisted_customers_path)
    within("#blocklisted_customer_#{blocked_customer.id}") do
      click_on 'ver detalhes'
    end

    within('div#customer_details') do
      expect(page).to have_field('Nome:', with: 'José da Silva', disabled: true)
      expect(page).to have_field('Número do documento:', with: '12312312312', disabled: true)
      expect(page).to have_field('Razão para bloqueio:', count: 0)
    end
    within('tbody') do
      expect(page).to have_css('tr', count: 1)
      expect(page).not_to have_content('Cliente 2 bloqueado.')
    end
  end

  it 'tries to block a customer that does not exist' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

    mocked_api_response = double({ status: 404, body: JSON.generate({}) })

    url = "#{Rails.configuration.external_apis['customer_api_url']}/12312312312"
    allow(Faraday).to receive(:get).with(url).and_return(mocked_api_response)

    login_as(admin)

    visit(blocklisted_customers_path)
    fill_in 'search_doc_ident', with: '12312312312'
    click_on 'Buscar'

    expect(page).not_to have_css('div#customer_details')
    expect(page).to have_content('Cliente não encontrado')
  end

  it 'and there is no blocked customer' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

    login_as(admin)

    visit(blocklisted_customers_path)

    expect(page).to have_content('Não existem clientes bloqueados.')
    expect(page).not_to have_css('Documento de identidade')
    expect(page).not_to have_css('Razão do bloqueio')
  end

  it 'and receives an error message when the external API fails' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    url = "#{Rails.configuration.external_apis['customer_api_url']}/12312312312"
    allow(Faraday).to receive(:get).with(url).and_raise(Faraday::TimeoutError)

    login_as(admin)

    visit(blocklisted_customers_path)
    fill_in 'search_doc_ident', with: '12312312312'
    click_on 'Buscar'

    expect(page).to have_content('Problema ao acessar API de clientes')
  end
end
