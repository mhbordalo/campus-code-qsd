require 'rails_helper'

describe 'Admin acessa a tela inicial' do
  # rubocop:disable Metrics/BlockLength
  it 'e cria uma promoção com sucesso' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    json_data = Rails.root.join('spec/support/json/products.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/product_groups/').and_return(fake_response)

    visit root_path
    login_as(user)
    click_on 'Cadastrar Promoção'

    fill_in 'Nome', with: 'Promoção de Semana Santa'
    fill_in 'Código', with: 'SANTAPromoção'
    fill_in 'Data inicial', with: '10/03/2023'
    fill_in 'Data final', with: '25/03/2023'
    fill_in 'Desconto', with: '10'
    fill_in 'Valor máximo de desconto', with: '50.00'
    fill_in 'Quantidade de Cupons', with: 200
    check('Hospedagem de Site')
    check('Envio de E-mails')
    click_on 'Enviar'

    expect(page).to have_content 'Promoção cadastrada com sucesso.'
    expect(page).to have_content 'Pendente'
    expect(page).to have_content 'Nome: Promoção de Semana Santa'
    expect(page).to have_content 'Código: SANTAPROMOÇÃO'
    expect(page).to have_content "Criado por: #{user.email}"
    expect(page).to have_content 'Data inicial: 10/03/2023'
    expect(page).to have_content 'Data final: 25/03/2023'
    expect(page).to have_content 'Desconto: 10%'
    expect(page).to have_content 'Valor máximo de desconto: R$ 50,00'
    expect(page).to have_content 'Quantidade de Cupons: 200'
    expect(page).to have_content 'Produtos da promoção: ["Hospedagem de Site", "Envio de E-mails"]'
  end
  # rubocop:enable Metrics/BlockLength

  it 'não consegue criar uma promoção' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    json_data = Rails.root.join('spec/support/json/products.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/product_groups/').and_return(fake_response)

    visit root_path
    login_as(user)
    click_on 'Cadastrar Promoção'

    within('#promotion_add') do
      fill_in 'Nome', with: 'Promoção de Semana Santa'
      fill_in 'Código', with: ''
      fill_in 'Data inicial', with: '10/03/2023'
      fill_in 'Data final', with: '25/03/2023'
      fill_in 'Desconto', with: '10'
      fill_in 'Valor máximo de desconto', with: '50.00'
      fill_in 'Quantidade de Cupons', with: 200
      check('Hospedagem de Site')
      check('Envio de E-mails')
      click_on 'Enviar'
    end

    expect(page).to have_content 'Não foi possível cadastrar a promoção'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Código não pode ficar em branco'
  end

  context 'cadastra uma promoção' do
    it 'e um usuário diferente aprova' do
      User.create!(email: 'admin@locaweb.com.br', password: '12345678')
      user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
      json_data = Rails.root.join('spec/support/json/products.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/product_groups/').and_return(fake_response)
      create(:promotion, user_create: 1)

      visit root_path
      login_as(user)
      click_on 'Listar Promoções'
      click_on 'Detalhes da promoção'
      click_on 'Aprovar promoção'

      expect(page).to have_content 'Promoção aprovada com sucesso.'
      expect(page).to have_content "Aprovado por: #{user.email}"
    end

    it 'e o admin não consegue aprovar' do
      admin = User.create!(email: 'admin@locaweb.com.br', password: '12345678')
      create(:promotion, user_create: 1)
      json_data = Rails.root.join('spec/support/json/products.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/product_groups/').and_return(fake_response)

      visit root_path
      login_as(admin)
      click_on 'Listar Promoções'
      click_on 'Detalhes da promoção'
      click_on 'Aprovar promoção'

      expect(page).to have_content 'A promoção precisa ser aprovada por um usuário diferente daquele que a criou.'
      expect(page).to have_content 'Pendente'
    end

    it 'e não consegue acessar a API de produtos' do
      admin = User.create!(email: 'admin@locaweb.com.br', password: '12345678')

      visit root_path
      login_as(admin)
      click_on 'Cadastrar Promoção'

      expect(page).to have_content 'Falha ao acessar API de Produtos'
    end
  end
end
