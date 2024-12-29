require 'rails_helper'

describe 'Admin access paid commissions' do
  it 'with success' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

    login_as(admin)
    visit(root_path)
    click_on('Relatório de Comissões')

    expect(page).to have_content('Relatório de Comissões')
  end

  it 'and cant access as normal user' do
    user = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: false)

    login_as(user)
    visit(root_path)

    expect(page).not_to have_content('Relatório de Comissões')
  end

  it 'and cant access if not logged in' do
    visit(root_path)

    expect(page).not_to have_content('Relatório de Comissões')
  end

  it 'and view total paid commissions by salesman with no filter applied message and ordered by name' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    seller1 = create(:user, name: 'Maria Aguiar')
    seller2 = create(:user, name: 'José Silva')
    order1 =  create(:order, salesman: seller1)
    order2 =  create(:order, salesman: seller2)
    order3 =  create(:order, salesman: seller1)
    create(:paid_commission, order: order1, salesman: seller1, amount: 100)
    create(:paid_commission, order: order2, salesman: seller2, amount: 130)
    create(:paid_commission, order: order3, salesman: seller1, amount: 50)

    login_as(admin)
    visit(paid_commissions_path)

    expect(page).to have_content('Nenhum filtro aplicado')
    within('tbody') do
      expect(page).to have_css('tr', count: 2)
      tr = find('tr', match: :first)
      expect(tr).to have_content('José Silva R$ 130,00')
      expect(page).to have_content('Maria Aguiar R$ 150,00')
    end
  end

  it 'and view empty table if there is no paid commissions' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

    login_as(admin)
    visit(paid_commissions_path)

    within('tbody') do
      expect(page).to have_css('tr', count: 0)
    end
  end

  it 'and click on details to view detailed commissions reverse ordered by date' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    seller1 = create(:user, name: 'Maria Aguiar')
    seller2 = create(:user, name: 'José Silva')
    order1 =  create(:order, salesman: seller1)
    order2 =  create(:order, salesman: seller2)
    order3 =  create(:order, salesman: seller1)
    bonus = create(:bonus_commission)
    create(:paid_commission, order: order1, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2022-12-10', amount: 100)
    create(:paid_commission, order: order2, bonus_commission: bonus,
                             salesman: seller2, paid_at: '2023-01-05', amount: 130)
    create(:paid_commission, order: order3, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2023-02-15', amount: 50)

    login_as(admin)
    visit(paid_commissions_path)
    within("#user_#{seller1.id}") do
      click_on 'Detalhes'
    end

    expect(page).to have_content('Detalhes de Comissões')
    expect(page).to have_content(seller1.name)
    within('tbody') do
      expect(page).to have_css('tr', count: 2)
      tr = find('tr', match: :first)
      expect(tr).to have_content('R$ 50,00')
      expect(page).to have_content('R$ 100,00')
    end
  end

  it 'and can filter by name' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    seller1 = create(:user, name: 'Maria Aguiar')
    seller2 = create(:user, name: 'José Silva')
    order1 =  create(:order, salesman: seller1)
    order2 =  create(:order, salesman: seller2)
    order3 =  create(:order, salesman: seller1)
    bonus = create(:bonus_commission)
    create(:paid_commission, order: order1, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2022-12-10', amount: 100)
    create(:paid_commission, order: order2, bonus_commission: bonus,
                             salesman: seller2, paid_at: '2023-01-05', amount: 130)
    create(:paid_commission, order: order3, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2023-02-15', amount: 50)

    login_as(admin)
    visit(paid_commissions_path)
    fill_in 'search_salesman', with: 'ari'
    click_on 'Buscar'

    expect(page).to have_content('Relatório de Comissões')
    expect(page).to have_content('De: primeiro dado disponível até: último dado disponível')
    within('tbody') do
      expect(page).to have_css('tr', count: 1)
      tr = find('tr', match: :first)
      expect(tr).to have_content('Maria Aguiar R$ 150,00')
      expect(tr).not_to have_content('José Silva R$ 130,00')
    end
  end

  it 'and can filter by date' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    seller1 = create(:user, name: 'Maria Aguiar')
    seller2 = create(:user, name: 'José Silva')
    order1 =  create(:order, salesman: seller1)
    order2 =  create(:order, salesman: seller2)
    order3 =  create(:order, salesman: seller1)
    bonus = create(:bonus_commission)
    create(:paid_commission, order: order1, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2022-12-10', amount: 100)
    create(:paid_commission, order: order2, bonus_commission: bonus,
                             salesman: seller2, paid_at: '2023-01-05', amount: 130)
    create(:paid_commission, order: order3, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2023-02-15', amount: 50)

    login_as(admin)
    visit(paid_commissions_path)
    fill_in 'start_date', with: '2022-12-11'
    fill_in 'end_date', with: '2023-01-05'
    click_on 'Buscar'

    expect(page).to have_content('Relatório de Comissões')
    expect(page).to have_content('De: 11/12/2022 até: 05/01/2023')
    within('tbody') do
      expect(page).to have_css('tr', count: 1)
      tr = find('tr', match: :first)
      expect(tr).to have_content('José Silva R$ 130,00')
      expect(tr).not_to have_content('Maria Aguiar R$ 150,00')
    end
  end

  it 'and also filter in details page date' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    seller1 = create(:user, name: 'Maria Aguiar')
    seller2 = create(:user, name: 'José Silva')
    order1 =  create(:order, salesman: seller1)
    order2 =  create(:order, salesman: seller2)
    order3 =  create(:order, salesman: seller1)
    bonus = create(:bonus_commission)
    create(:paid_commission, order: order1, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2022-12-10', amount: 100)
    create(:paid_commission, order: order2, bonus_commission: bonus,
                             salesman: seller2, paid_at: '2023-01-05', amount: 130)
    create(:paid_commission, order: order3, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2023-02-15', amount: 50)

    login_as(admin)
    visit(paid_commissions_path)
    fill_in 'start_date', with: '2023-02-01'
    click_on 'Buscar'
    within("#user_#{seller1.id}") do
      click_on 'Detalhes'
    end

    expect(page).to have_content('Detalhes de Comissões')
    expect(page).to have_content(seller1.name)
    expect(page).to have_content('De: 01/02/2023 até: último dado disponível')
    within('tbody') do
      expect(page).to have_css('tr', count: 1)
      tr = find('tr', match: :first)
      expect(tr).to have_content('R$ 50,00')
      expect(page).not_to have_content('R$ 100,00')
    end
  end

  it 'and view message if there is no satisfying data' do
    admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
    seller1 = create(:user, name: 'Maria Aguiar')
    seller2 = create(:user, name: 'José Silva')
    order1 =  create(:order, salesman: seller1)
    order2 =  create(:order, salesman: seller2)
    order3 =  create(:order, salesman: seller1)
    bonus = create(:bonus_commission)
    create(:paid_commission, order: order1, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2022-12-10', amount: 100)
    create(:paid_commission, order: order2, bonus_commission: bonus,
                             salesman: seller2, paid_at: '2023-01-05', amount: 130)
    create(:paid_commission, order: order3, bonus_commission: bonus,
                             salesman: seller1, paid_at: '2023-02-15', amount: 50)

    login_as(admin)
    visit(paid_commissions_path)
    fill_in 'start_date', with: '2023-02-20'
    click_on 'Buscar'

    expect(page).to have_content('Relatório de Comissões')
    expect(page).to have_content('Não foram encontradas comissões pagas para esse critério')
    expect(page).to have_content('Não foram encontrados registros que satisfaçam essa pesquisa.')
    expect(page).to have_css('table', count: 0)
  end
end
