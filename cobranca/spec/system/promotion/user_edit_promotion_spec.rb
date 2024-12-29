require 'rails_helper'

describe 'Admin acessa a tela inicial' do
  it 'e edita uma promoção com sucesso' do
    User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    Promotion.create!(name: 'Promoção Campus Code', start: '2023-01-05',
                      finish: '2023-03-31', discount: 5,
                      maximum_discount_value: 250.5, coupon_quantity: 20, status: 0,
                      approve_date: '2023-01-01', approval_date: '2023-01-01', user_create: 1,
                      user_aprove: 2, code: 'CAMPUSCODE', products: %w[SITE EMAIL])

    visit root_path
    login_as(user)
    click_on 'Listar Promoções'
    click_on 'Detalhes da promoção'
    click_on 'Editar'

    fill_in 'Código', with: 'SANTA PROMOÇÃO'
    fill_in 'Desconto', with: '10'
    fill_in 'Valor máximo de desconto', with: '120.00'

    click_on 'Enviar'

    expect(page).to have_content 'Promoção atualizada com sucesso.'
    expect(page).to have_content 'Código: SANTA PROMOÇÃO'
    expect(page).to have_content 'Desconto: 10%'
    expect(page).to have_content 'Valor máximo de desconto: R$ 120,00'
  end

  it 'e edita uma promoção com falha' do
    User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    user = User.create!(email: 'user@locaweb.com.br', password: '12345678')
    Promotion.create!(name: 'Promoção Campus Code', start: '2023-01-05',
                      finish: '2023-03-31', discount: 5,
                      maximum_discount_value: 250.5, coupon_quantity: 20, status: 0,
                      approve_date: '2023-01-01', approval_date: '2023-01-01', user_create: 1,
                      user_aprove: 2, code: 'CAMPUSCODE', products: %w[SITE EMAIL])

    visit root_path
    login_as(user)
    click_on 'Listar Promoções'
    click_on 'Detalhes da promoção'
    click_on 'Editar'

    fill_in 'Código', with: 'SANTA PROMOÇÃO'
    fill_in 'Desconto', with: '10'
    fill_in 'Valor máximo de desconto', with: ''

    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível atualizar a promoção.'
    expect(page).to_not have_content 'Código: SANTA PROMOÇÃO'
    expect(page).to_not have_content 'Desconto: 10%'
    expect(page).to_not have_content 'Valor máximo de desconto: R$ 120,00'
  end
end
