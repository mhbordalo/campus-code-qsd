require 'rails_helper'

describe 'ator não logado requisita telas de instalação de produtos' do
  it 'lista de itens' do
    get(install_products_path)

    expect(response).to redirect_to(new_user_session_path)
  end
end
