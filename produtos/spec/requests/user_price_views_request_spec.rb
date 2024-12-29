require 'rails_helper'

describe 'ator não logado requisita telas de preço' do
  it 'lista de itens' do
    get(prices_path)

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'formulário de registro' do
    post(prices_path, params: {})

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'formulário de edição' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    plan = create(:plan, name: 'Hospedagem de Site', product_group:, status: :active,
                         description: '1 Site, 3 Contas de e-mails (10GB cada), 1 ano de domínio grátis',
                         details: '1 usuário FTP, Armazenamento ilimitado, Transferencia ilimitada')
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)
    price = create(:price, price: 20.00, plan:, periodicity:)

    patch(price_path(price.id), params: { price: 30.00, periodicity:, plan: })

    expect(response).to redirect_to(new_user_session_path)
  end
end
