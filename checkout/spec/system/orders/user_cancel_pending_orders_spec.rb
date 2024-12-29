require 'rails_helper'

describe 'Orders Cancel' do
  it 'Salesman should only see one the cancel button at the Orders list page' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)

    create(:order, salesman_id: salesman.id, price: '300.00',
                   product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                   product_plan_id: 1, product_plan_name: 'Hospedagem GO',
                   status: Order.statuses[:pending])
    create(:order, salesman_id: salesman.id,
                   product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                   product_plan_id: 2, product_plan_name: 'Hospedagem XYZ', price: '500.00',
                   status: Order.statuses[:paid])
    create(:order, salesman_id: salesman.id,
                   product_group_id: 1, product_group_name: 'Hospedagem de Sites',
                   product_plan_id: 3, product_plan_name: 'Hospedagem XYZ', price: '500.00',
                   cancel_reason: 'Cliente desistiu',
                   status: Order.statuses[:cancelled])

    login_as(salesman)
    visit(root_path)
    click_on('Pedidos')

    expect(page).to have_css('button.button_cancel', count: 1, text: 'Cancelar')
  end

  it 'Salesman should be able to click one the cancel button at the Orders list page' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)

    order_pending = create(:order, salesman_id: salesman.id,
                                   status: Order.statuses[:pending])
    create(:order, salesman_id: salesman.id,
                   status: Order.statuses[:paid])
    create(:order, salesman_id: salesman.id,
                   cancel_reason: 'Cliente desistiu',
                   status: Order.statuses[:cancelled])

    login_as(salesman)
    visit(root_path)
    click_on('Pedidos')
    click_on('Cancelar')

    expect(current_path).to eq(order_cancel_reason_order_path(order_pending.id))
  end

  it 'Salesman completes the cancellation action with success' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)

    order_pending = create(:order, salesman_id: salesman.id,
                                   status: Order.statuses[:pending])
    create(:order, salesman_id: salesman.id,
                   status: Order.statuses[:paid])
    create(:order, salesman_id: salesman.id,
                   cancel_reason: 'Cliente desistiu',
                   status: Order.statuses[:cancelled])

    login_as(salesman)
    visit(root_path)
    click_on('Pedidos')
    click_on('Cancelar')
    fill_in 'Motivo do cancelamento', with: 'O cliente desisitiu.'
    click_on('Enviar')

    expect(current_path).to eq(orders_path)
    expect(page).to have_content("Ordem #{order_pending.order_code} cancelada")
  end

  it 'Salesman cant completes the cancellation without providing a reason' do
    salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)

    create(:order, salesman_id: salesman.id,
                   status: Order.statuses[:pending])
    create(:order, salesman_id: salesman.id,
                   status: Order.statuses[:paid])
    create(:order, salesman_id: salesman.id,
                   cancel_reason: 'Cliente desistiu',
                   status: Order.statuses[:cancelled])

    login_as(salesman)
    visit(root_path)
    click_on('Pedidos')
    click_on('Cancelar')
    click_on('Enviar')

    expect(current_path).not_to eq(orders_path)
    expect(page).to have_content('O motivo do cancelamento precisa ser preenchido')
  end
end
