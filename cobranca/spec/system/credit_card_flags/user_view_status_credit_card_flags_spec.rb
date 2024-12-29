require 'rails_helper'
describe 'Usuário acessa bandeira de cartão de crédito' do
  it 'mas não vê bandeiras ativas e inativas cadastradas' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    expect(page).to have_content 'Não há Bandeiras de Cartão de Crédito ativadas cadastradas.'
    expect(page).to have_content 'Não há Bandeiras de Cartão de Crédito desativadas cadastradas.'
  end
  it 'e vê bandeiras ativadas cadastradas, mas não vê inativadas' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                              cash_purchase_discount: 'T', status: :activated)
    flag.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                        filename: 'visa.png', content_type: 'image/png')
    flag.save!
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    expect(page).not_to have_content 'Não há Bandeiras de Cartão de Crédito ativadas cadastradas.'
    expect(page).to have_content 'Não há Bandeiras de Cartão de Crédito desativadas cadastradas.'
  end
  it 'e vê bandeiras desativadas cadastradas, mas não vê ativadas' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                              cash_purchase_discount: 'T', status: :deactivated)
    flag.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                        filename: 'visa.png', content_type: 'image/png')
    flag.save!
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    expect(page).to have_content 'Não há Bandeiras de Cartão de Crédito ativadas cadastradas.'
    expect(page).not_to have_content 'Não há Bandeiras de Cartão de Crédito desativadas cadastradas.'
  end
  it 'e vê bandeiras ativadas e desativadas cadastradas' do
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    flag1 = CreditCardFlag.new(name: 'VISA1', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                               cash_purchase_discount: 'T', status: :deactivated)
    flag1.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                         filename: 'visa.png', content_type: 'image/png')
    flag1.save!
    flag2 = CreditCardFlag.new(name: 'VISA2', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                               cash_purchase_discount: 'T', status: :activated)
    flag2.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open,
                         filename: 'visa.png', content_type: 'image/png')
    flag2.save!
    visit root_path
    login_as(user)
    click_on 'Bandeiras de Cartão de Crédito'
    expect(page).not_to have_content 'Não há Bandeiras de Cartão de Crédito ativadas cadastradas.'
    expect(page).not_to have_content 'Não há Bandeiras de Cartão de Crédito desativadas cadastradas.'
  end
end
