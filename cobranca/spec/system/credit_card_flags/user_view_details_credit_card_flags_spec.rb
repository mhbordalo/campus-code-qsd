require 'rails_helper'

describe 'Usuário vê detalhes da Bandeira do Cartão de Crédito' do
  it 'a partir da lista das bandeiras cadastradas' do
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
    expect(current_path).to eq credit_card_flag_path(flag.id)
    expect(page).to have_content 'VISA'
    expect(page).to have_content 'Taxa cobrada (%): 4'
    expect(page).to have_content 'Valor máximo da taxa cobrada (R$): 1000'
    expect(page).to have_content 'Nº máximo de parcelas: 6'
    expect(page).to have_content 'Desconto: Sim'
    expect(page).to have_content 'Situação: Ativada'
  end
  it 'e volta para o menu' do
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
    click_on 'Voltar'
    expect(current_path).to eq credit_card_flags_path
  end
end
