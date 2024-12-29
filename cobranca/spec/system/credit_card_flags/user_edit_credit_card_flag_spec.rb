require 'rails_helper'

describe 'Usuário edita os dados de uma Bandeira do Cartão de Crédito' do
  it 'a partir da tela de detalhes' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                              cash_purchase_discount: 'T', status: :activated)
    flag.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                        filename: 'visa.png', content_type: 'image/png')
    flag.save!
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    click_on 'VISA'
    click_on 'Editar informações'
    expect(current_path).to eq edit_credit_card_flag_path(flag.id)
    expect(page).to have_field 'Nome', with: 'VISA'
    expect(page).to have_field 'Taxa cobrada (%)', with: 4
    expect(page).to have_field 'Valor máximo da taxa cobrada (R$)', with: 1000
    expect(page).to have_field 'Nº máximo de parcelas', with: 6
    expect(page).to have_field 'Desconto', with: 'true'
  end
  it 'com sucesso' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                              cash_purchase_discount: 'T', status: :activated)
    flag.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                        filename: 'visa.png', content_type: 'image/png')
    flag.save!
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    click_on 'VISA'
    click_on 'Editar informações'
    fill_in 'Taxa cobrada (%)', with: 5
    fill_in 'Valor máximo da taxa cobrada (R$)', with: 2000
    fill_in 'Nº máximo de parcelas', with: 4
    select 'Sim', from: 'Desconto'
    click_on 'Enviar'
    expect(page).to have_content 'Bandeira de cartão de crédito atualizada com sucesso.'
    expect(page).to have_content 'VISA'
    expect(page).to have_content 'Taxa cobrada (%): 5'
    expect(page).to have_content 'Valor máximo da taxa cobrada (R$): 2000'
    expect(page).to have_content 'Nº máximo de parcelas: 4'
    expect(page).to have_content 'Desconto: Sim'
  end
  it 'e mantám os campos obrigatórios' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                              cash_purchase_discount: 'T', status: :activated)
    flag.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                        filename: 'visa.png', content_type: 'image/png')
    flag.save!
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    click_on 'VISA'
    click_on 'Editar informações'
    fill_in 'Nome', with: ''
    fill_in 'Taxa cobrada (%)', with: ''
    fill_in 'Valor máximo da taxa cobrada (R$)', with: ''
    fill_in 'Nº máximo de parcelas', with: ''
    click_on 'Enviar'
    expect(page).to have_content 'Não foi possível atualizar a bandeira de cartão de crédito.'
  end
end
