# rubocop:disable Style/NumericLiterals, Metrics/BlockLength

User.create(email: 'usuario@locaweb.com.br', password: '12345678')
User.create(email: 'admin@locaweb.com.br', password: '12345678', user_type: :admin)

flag1 = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                           cash_purchase_discount: 'T', status: :activated)
flag1.picture.attach(io: Rails.root.join('app/assets/images/visa.png').open, filename: 'visa.png',
                     content_type: 'image/png')
flag1.save!
flag2 = CreditCardFlag.new(name: 'AMERICAN EXPRESS', rate: 5, maximum_value: 2_000, maximum_number_of_installments: 7,
                           cash_purchase_discount: 'T', status: :activated)
flag2.picture.attach(io: Rails.root.join('app/assets/images/americanexpress.png').open, filename: 'americanexpress.png',
                     content_type: 'image/png')
flag2.save!
flag3 = CreditCardFlag.new(name: 'MASTERCARD', rate: 6, maximum_value: 1_000, maximum_number_of_installments: 8,
                           cash_purchase_discount: 'F', status: :activated)
flag3.picture.attach(io: Rails.root.join('app/assets/images/mastercard.png').open, filename: 'mastercard.png',
                     content_type: 'image/png')
flag3.save!

private

def show_spinner(msg_start, msg_stop = 'Concluído')
  spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
  spinner.auto_spin
  yield
  spinner.success("(#{msg_stop})")
end

public

show_spinner('Inserindo cartão...') do
  credit_cards = [
    {
      card_number: 1234567890123456,
      validate_month: 5,
      validate_year: 23,
      cvv: 100,
      owner_name: 'Maria Celia Alves',
      owner_doc: 92241199567,
      credit_card_flag_id: 1
    },
    {
      card_number: 9876534253647567,
      validate_month: 7,
      validate_year: 28,
      cvv: 987,
      owner_name: 'Giordano Bruno',
      owner_doc: 28341727145,
      credit_card_flag_id: 2
    },
    {
      card_number: 8765987643526374,
      validate_month: 11,
      validate_year: 26,
      cvv: 648,
      owner_name: 'Guimarães Rosa',
      owner_doc: 44351758198,
      credit_card_flag_id: 3
    }
  ]

  credit_cards.each do |credit_card|
    CreditCard.create!(credit_card)
  end
end

show_spinner('Inserindo cobranças...') do
  charges = [
    {
      charge_status: :pending,
      approve_transaction_number: '',
      reasons_id: 0,
      creditcard_token: CreditCard.find(1).token,
      client_cpf: '92241199567',
      order: 'YI12C8UAJB',
      final_value: 10_000.00
    },
    {
      charge_status: :pending,
      approve_transaction_number: '',
      reasons_id: 0,
      creditcard_token: CreditCard.find(2).token,
      client_cpf: '28341727145',
      order: 'YI12C91AJB',
      final_value: 7_200.00
    },
    {
      charge_status: :pending,
      approve_transaction_number: '',
      reasons_id: 0,
      creditcard_token: CreditCard.find(3).token,
      client_cpf: '44351758198',
      order: 'YI42H8UAJB',
      final_value: 5_500.00
    }
  ]

  charges.each do |charge|
    Charge.find_or_create_by(charge)
  end
end

show_spinner('Inserindo motivos de reprovação da cobrança...') do
  reasons = [
    {
      code: 199,
      description: 'Cartão sem saldo'
    },
    {
      code: 101,
      description: 'Cartão sem limite'
    },
    {
      code: 102,
      description: 'Cartão bloqueado'
    },
    {
      code: 103,
      description: 'Cartão roubado'
    },
    {
      code: 104,
      description: 'Número de parcelas inválido'
    },
    {
      code: 105,
      description: 'Sem conexão com o banco'
    }
  ]

  reasons.each do |reason|
    Reason.find_or_create_by(reason)
  end
end

show_spinner('Inserindo promoção...') do
  promotions = [
    {
      name: 'Promoção Campus Code',
      start: '2023-01-05',
      finish: '2023-03-31',
      discount: 5,
      maximum_discount_value: 250.5,
      coupon_quantity: 20,
      status: 9,
      approve_date: '2023-01-01',
      approval_date: '2023-01-01',
      user_create: 1,
      user_aprove: 2,
      code: 'CAMPUSCODE',
      products: %w[SITE EMAIL]
    }
  ]

  promotions.each do |promotion|
    Promotion.find_or_create_by(promotion)
  end
end

show_spinner('Gerando cupons da promoção...') do
  coupons = [
    {
      code: 'CAMPUSCODE-XLIR9',
      promotion_id: 1,
      status: 0
    }
  ]

  coupons.each do |coupon|
    Coupon.find_or_create_by(coupon)
  end
end
# rubocop:enable Style/NumericLiterals, Metrics/BlockLength
