require 'rails_helper'

describe 'Usuário altera status de uma bandeira' do
  it 'para desativada' do
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
    click_on 'Marcar como DESATIVADA'
    expect(current_path).to eq credit_card_flag_path(flag.id)
    expect(page).to have_button 'Marcar como ATIVADA'
    expect(page).not_to have_button 'Marcar como DESATIVADA'
  end
  it 'para ativada' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                              cash_purchase_discount: 'T', status: :deactivated)
    flag.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                        filename: 'visa.png', content_type: 'image/png')
    flag.save!
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    click_on 'VISA'
    click_on 'Marcar como ATIVADA'
    expect(current_path).to eq credit_card_flag_path(flag.id)
    expect(page).to have_button 'Marcar como DESATIVADA'
    expect(page).not_to have_button 'Marcar como ATIVADA'
  end
end
