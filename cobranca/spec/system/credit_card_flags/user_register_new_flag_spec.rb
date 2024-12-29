require 'rails_helper'

describe 'Usuário cadastra uma nova bandeira' do
  it 'a partir da tela inicial' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    visit root_path
    login_as(user)
    click_on 'Cadastrar Bandeira'
    expect(page).to have_field('Nome')
    expect(page).to have_field('Taxa cobrada (%)')
    expect(page).to have_field('Valor máximo da taxa cobrada (R$)')
    expect(page).to have_field('Nº máximo de parcelas')
    expect(page).to have_field('Desconto')
  end
  it 'com sucesso' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    visit root_path
    login_as(user)
    click_on 'Cadastrar Bandeira'
    fill_in 'Nome', with: 'VISA'
    attach_file('credit_card_flag_picture', Rails.root.join('app/assets/images/visa.png'))
    fill_in 'Taxa cobrada (%)', with: 5
    fill_in 'Valor máximo da taxa cobrada (R$)', with: 2000
    fill_in 'Nº máximo de parcelas', with: 4
    select 'Sim', from: 'Desconto'
    click_on 'Enviar'
    expect(page).to have_content('Bandeira cadastrada com sucesso.')
    expect(page).to have_content('VISA')
  end
  it 'com dados incompletos' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                              cash_purchase_discount: 'T', status: :activated)
    flag.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                        filename: 'visa.png', content_type: 'image/png')
    flag.save!
    visit root_path
    login_as(user)
    click_on 'Cadastrar Bandeira'
    fill_in 'Nome', with: ''
    fill_in 'Taxa cobrada (%)', with: ''
    fill_in 'Valor máximo da taxa cobrada (R$)', with: ''
    fill_in 'Nº máximo de parcelas', with: ''
    select 'Sim', from: 'Desconto'
    click_on 'Enviar'
    expect(page).to have_content 'Bandeira não cadastrada.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Taxa cobrada (%) não pode ficar em branco'
    expect(page).to have_content 'Valor máximo da taxa cobrada (R$) não pode ficar em branco'
    expect(page).to have_content 'Nº máximo de parcelas não pode ficar em branco'
  end
end
