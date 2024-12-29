require 'rails_helper'

describe 'Usuário vê relação de cobranças pendentes' do
  it 'não tem cobrança pendente' do
    visit root_path
    user = User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    login_as(user)
    within('ul.menu') do
      click_on 'Cobranças Pendentes'
    end
    expect(page).to have_content('Não existem cobraças pendentes')
  end

  it 'e vê cobranças pendentes com sucesso' do
    user = User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    reason = Reason.create!(code: 199, description: 'Cartão sem saldo')
    create(:credit_card_flag)
    credit_card = create(:credit_card)

    Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                   creditcard_token: credit_card.token,
                   client_cpf: '628.006.557-04', order: '1000', final_value: 10_000.00)

    Charge.create!(charge_status: :reproved, approve_transaction_number: '', reasons_id: reason,
                   creditcard_token: credit_card.token,
                   client_cpf: '741.258.963-07', order: '1001', final_value: 7_200.00)

    Charge.create!(charge_status: :aproved, approve_transaction_number: '2d931510-d99f-494a-8c67-87feb05e1594',
                   reasons_id: 0, creditcard_token: credit_card.token,
                   client_cpf: '798.456.123-00', order: '1002', final_value: 5_500.00)

    visit root_path
    login_as(user)

    within('ul.menu') do
      click_on 'Cobranças Pendentes'
    end

    expect(page).to have_content '628.006.557-04'
    expect(page).not_to have_content '094.400.957-33'
    expect(page).not_to have_content '801.662.331-02'
  end

  it 'e aprova uma cobrança' do
    user = User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    create(:credit_card_flag)
    credit_card = create(:credit_card)

    Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                   creditcard_token: credit_card.token,
                   client_cpf: '628.006.557-04', order: '1000', final_value: 10_000.00)

    cobranca1 = Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                               creditcard_token: credit_card.token,
                               client_cpf: '789.456.123-09', order: '1001', final_value: 5_500.00)

    visit root_path
    login_as(user)
    within('ul.menu') do
      click_on 'Cobranças Pendentes'
    end
    within("#charge_#{cobranca1.id}") do
      click_on 'Aprovar'
    end

    within('form#form1') do
      fill_in 'Código de Aprovação', with: '0001'
      click_on 'Aprovar Cobrança'
    end

    expect(page).not_to have_content '789.456.123-09'
    expect(page).to have_content '628.006.557-04'
    expect(page).to have_content 'A cobrança foi aprovada com sucesso'
  end

  it 'e clica em reprovar uma cobrança' do
    user = User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    create(:credit_card_flag)
    credit_card = create(:credit_card)

    Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                   creditcard_token: credit_card.token,
                   client_cpf: '789.456.123-09', order: '1000', final_value: 5_500.00)

    cobranca1 = Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                               creditcard_token: credit_card.token,
                               client_cpf: '628.006.557-04', order: '1001', final_value: 10_000.00)

    visit root_path
    login_as(user)
    within('ul.menu') do
      click_on 'Cobranças Pendentes'
    end
    within("#charge_#{cobranca1.id}") do
      click_on 'Reprovar'
    end

    expect(current_path).to eq(charge_path(cobranca1.id))
    expect(page).to have_content 'CPF: 628.006.557-04'
    expect(page).to have_content 'Número do Pedido: 1001'
    expect(page).to have_content 'Valor Final: R$ 10.000,00'
    expect(page).to have_field('code')
    expect(page).to have_button 'Reprovar Cobrança'
  end

  it 'e reprova uma cobrança' do
    user = User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    Reason.create!(code: 199, description: 'Saldo Insuficiente')
    create(:credit_card_flag)
    credit_card = create(:credit_card)

    Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                   creditcard_token: credit_card.token,
                   client_cpf: '789.456.123-09', order: '1000', final_value: 5_500.00)

    cobranca1 = Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                               creditcard_token: credit_card.token,
                               client_cpf: '628.006.557-04', order: '1001', final_value: 10_000.00)

    visit root_path
    login_as(user)
    within('ul.menu') do
      click_on 'Cobranças Pendentes'
    end
    within("#charge_#{cobranca1.id}") do
      click_on 'Reprovar'
    end

    within('form#form1') do
      select 'Saldo Insuficiente', from: 'code'
      click_on 'Reprovar Cobrança'
    end

    expect(page).not_to have_content '628.006.557-04'
    expect(page).to have_content 'A cobrança foi reprovada com sucesso.'
  end
end
