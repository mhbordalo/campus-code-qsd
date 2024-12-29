require 'rails_helper'

describe 'User approval sends payment mode to order API at Checkout' do
  it 'and an error is logged if a problem on API processing' do # rubocop:disable Metrics/BlockLength
    user = User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    create(:credit_card_flag)
    credit_card = create(:credit_card)

    cobranca1 = Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                               creditcard_token: credit_card.token,
                               client_cpf: '789.456.123-09', order: '1001', final_value: 5_500.00)
    approval_code = '0001'
    payload = { charge: { approve_transaction_number: approval_code, disapproved_code: '', disapproved_reason: '',
                          client_doc: cobranca1.client_cpf, order_code: cobranca1.order } }.to_json
    url1 = 'http://localhost:3001/api/v1/orders/1001/pay'
    url2 = 'http://localhost:3002/api/v1/order/paid'
    allow(Rails.logger).to receive(:error)
    allow(Faraday).to receive(:post).with(url1, { payment_mode: 'credit_card' }.to_json,
                                          { 'Content-Type' => 'application/json' }).and_return({ status: 504 })
    allow(Faraday).to receive(:post).with(url2, payload, { 'Content-Type' => 'application/json' })
                                    .and_return({ status: 201 })

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

    expect(page).to have_content 'A cobrança foi aprovada com sucesso'
    expect(Rails.logger).to have_received(:error)
                        .with('ERRO: Não foi possível atualizar o modo de pagamento do pedido 1001')
  end

  it 'and an error is logged if a problem to access API' do # rubocop:disable Metrics/BlockLength
    user = User.create!(email: 'admin@locaweb.com.br', password: '12345678')
    create(:credit_card_flag)
    credit_card = create(:credit_card)

    cobranca1 = Charge.create!(charge_status: :pending, approve_transaction_number: '', reasons_id: 0,
                               creditcard_token: credit_card.token,
                               client_cpf: '789.456.123-09', order: '1001', final_value: 5_500.00)

    approval_code = '0001'
    payload = { charge: { approve_transaction_number: approval_code, disapproved_code: '', disapproved_reason: '',
                          client_doc: cobranca1.client_cpf, order_code: cobranca1.order } }.to_json
    url1 = 'http://localhost:3001/api/v1/orders/1001/pay'
    url2 = 'http://localhost:3002/api/v1/order/paid'
    allow(Rails.logger).to receive(:error)
    allow(Faraday).to receive(:post).with(url1, { payment_mode: 'credit_card' }.to_json,
                                          { 'Content-Type' => 'application/json' }).and_raise(Faraday::ConnectionFailed)
    allow(Faraday).to receive(:post).with(url2, payload, { 'Content-Type' => 'application/json' })
                                    .and_return({ status: 201 })

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

    expect(page).to have_content 'A cobrança foi aprovada com sucesso'
    expect(Rails.logger).to have_received(:error)
                        .with("ERRO: Falha ao acessar #{url1} para gravar o modo de pagamento do pedido 1001")
  end
end
