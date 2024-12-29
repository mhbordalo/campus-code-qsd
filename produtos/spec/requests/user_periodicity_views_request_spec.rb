require 'rails_helper'

describe 'ator não logado requisita telas de periodicidade' do
  it 'lista de itens' do
    get(periodicities_path)

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'formulário de registro' do
    post(periodicities_path, params: {})

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'formulário de edição' do
    periodicity = create(:periodicity, name: 'Mensal', deadline: 1)

    patch(periodicity_path(periodicity.id), params: { periodicity: })

    expect(response).to redirect_to(new_user_session_path)
  end
end
