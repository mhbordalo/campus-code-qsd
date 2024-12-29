require 'rails_helper'
describe 'Usuário vê bandeiras de cartão de crédito' do
  it 'se não estiver autenticado' do
    visit root_path
    expect(current_path).to eq new_user_session_path
  end
  it 'a partir do menu' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    expect(current_path).to eq credit_card_flags_path
    expect(page).to have_content 'Bandeiras de Cartão de Crédito'
  end
  it 'e vê as imagens das bandeiras de cartão de crédito cadastradas' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                              cash_purchase_discount: 'T', status: :activated)
    flag.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                        filename: 'visa.png', content_type: 'image/png')
    flag.save!
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    within("#credit_card_flag_#{flag.id}") do
      expect(page).to have_css("img[src*='visa.png']")
      expect(page).to have_content 'VISA'
    end
  end
end
