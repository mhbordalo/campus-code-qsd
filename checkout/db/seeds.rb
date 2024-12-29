User.create!(name: 'admin', email: 'admin@locaweb.com.br', password: '12345678', admin: true)
salesman1 = User.create!(name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
salesman2 = User.create!(name: 'Antônio Souza', email: 'asouza@locaweb.com.br', password: '12345678')
salesman3 = User.create!(name: 'Maria do Rosário', email: 'mrosario@locaweb.com.br', password: '12345678')

customers = %w[66496875294 73787269231 98208142433]
statuses = [0, 2, 3, 5]

salesmen = [salesman1, salesman2, salesman3]
products = [['Hospedagem de Sites', 1], ['Email Locaweb', 2], ['Criador de Sites', 3]]
plans = [[['Hospedagem GO', 1], ['Hospedagem I', 2], ['Hospedagem II', 3]],
         [['Initial 25', 6], ['Initial 50', 7], ['Initial 100', 8]],
         [['Básico', 9], ['Intermediário', 10], ['Avançado', 11]]]
prices = [[[['Trimestral', 1, 38.97], ['Anual', 2, 119.88]],
           [['Trimestral', 3, 59.97], ['Anual', 4, 191.88]],
           [['Trimestral', 5, 80.97], ['Anual', 6, 299.88]]],
          [[['Trimestral', 11, 106.50], ['Anual', 12, 390]],
           [['Trimestral', 13, 46.80], ['Anual', 14, 136.50]],
           [['Trimestral', 17, 181.50], ['Anual', 18, 690]]],
          [[['Trimestral', 19, 20.70], ['Anual', 20, 58.80]],
           [['Trimestral', 21, 47.70], ['Anual', 22, 178.80]],
           [['Trimestral', 23, 77.70], ['Anual', 24, 298.80]]]]

# rubocop:disable Metrics/BlockLength
(Time.zone.today.at_beginning_of_month..Time.zone.today.at_end_of_month).each do |date|
  rand(20).times do
    salesmen_idx = rand(3)
    customer_idx = rand(3)
    prod_idx = rand(3)
    plan_idx = rand(3)
    price_idx = rand(2)
    status_idx = rand(4)

    t = Time.zone.now
    dt = DateTime.new(date.year, date.month, date.day, t.hour, t.min, t.sec, t.zone)

    o = Order.new(salesman_id: salesmen[salesmen_idx].id,
                  customer_doc_ident: customers[customer_idx],
                  product_group_id: products[prod_idx][1],
                  product_group_name: products[prod_idx][0],
                  product_plan_id: plans[prod_idx][plan_idx][1],
                  product_plan_name: plans[prod_idx][plan_idx][0],
                  product_plan_periodicity_id: prices[prod_idx][plan_idx][price_idx][1],
                  product_plan_periodicity: prices[prod_idx][plan_idx][price_idx][0],
                  price: prices[prod_idx][plan_idx][price_idx][2],
                  status: statuses[status_idx])
    o.created_at = dt
    o.updated_at = dt

    if o.paid?
      o.paid_at = o.created_at + 1.day
      o.payment_mode = 'credit_card'
    elsif o.cancelled?
      o.cancel_reason = 'Motivo cancelamento'
    end

    next if o.save

    o.errors.each do |msg|
      Rails.logger.info "  Error save order: #{msg.full_message}"
    end
  end
end
# rubocop:enable Metrics/BlockLength

salesman_one = User.create!(name: 'André Matos', email: 'andrem@locaweb.com.br', password: '12345678',
                            admin: false, active: true)
salesman_two = User.create!(name: 'Beatriz Azevedo', email: 'beatriza@locaweb.com.br', password: '12345678',
                            admin: false, active: true)
salesman_three = User.create!(name: 'Carlos Santos', email: 'amatos@locaweb.com.br', password: '12345678',
                              admin: false, active: true)
order1 = Order.create!(salesman_id: salesman_one.id, customer_doc_ident: '22200022201',
                       product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                       product_plan_id: 1, product_plan_name: 'Plano Bronze',
                       product_plan_periodicity_id: 1, product_plan_periodicity: 'Mensal', price: 30.00)
order2 = Order.create!(salesman_id: salesman_one.id, customer_doc_ident: '32100022201',
                       product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                       product_plan_id: 2, product_plan_name: 'Plano Prata',
                       product_plan_periodicity_id: 2, product_plan_periodicity: 'Mensal', price: 50.00)
order3 = Order.create!(salesman_id: salesman_one.id, customer_doc_ident: '42600022201',
                       product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                       product_plan_id: 3, product_plan_name: 'Plano Ouro',
                       product_plan_periodicity_id: 3, product_plan_periodicity: 'Anual', price: 70.00)
order4 = Order.create!(salesman_id: salesman_one.id, customer_doc_ident: '92220022201',
                       product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                       product_plan_id: 4, product_plan_name: 'Plano Platinum',
                       product_plan_periodicity_id: 4, product_plan_periodicity: 'Anual', price: 90.00)
Order.create!(salesman_id: salesman_two.id, customer_doc_ident: '22200022201',
              product_group_id: 1, product_group_name: 'Hospedagem de Sites',
              product_plan_id: 2, product_plan_name: 'Plano Prata',
              product_plan_periodicity_id: 2, product_plan_periodicity: 'Mensal', price: 50.00)
Order.create!(salesman_id: salesman_two.id, customer_doc_ident: '32100022201',
              product_group_id: 1, product_group_name: 'Hospedagem de Sites',
              product_plan_id: 3, product_plan_name: 'Plano Ouro',
              product_plan_periodicity_id: 3, product_plan_periodicity: 'Anual', price: 70.00)

bonus_commission1 = BonusCommission.create!(description: 'programa de incentivos 1', start_date: 1.day.from_now,
                                            end_date: 10.days.from_now, commission_perc: 3.5, amount_limit: 1000,
                                            active: false)

BlocklistedCustomer.create!(doc_ident: '18422142414', blocklisted_reason: 'Processo judicial em andamento.')

PaidCommission.create!(salesman: salesman_one, paid_at: '2022-01-01', amount: 100.00, order: order1,
                       bonus_commission: bonus_commission1)
PaidCommission.create!(salesman: salesman_two, paid_at: '2022-03-03', amount: 200.00, order: order2,
                       bonus_commission: bonus_commission1)
PaidCommission.create!(salesman: salesman_two, paid_at: '2022-04-03', amount: 50.00, order: order4,
                       bonus_commission: bonus_commission1)
PaidCommission.create!(salesman: salesman_three, paid_at: '2022-06-06', amount: 300.00, order: order3,
                       bonus_commission: bonus_commission1)

BonusCommission.create({ description: 'Bonus Especial', start_date: Date.current,
                         end_date: 2.days.from_now, commission_perc: '5', amount_limit: 100 })
