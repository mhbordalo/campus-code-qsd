require 'rails_helper'

describe 'Vendedor não admin não pode acessar área de vendedores' do
  it 'através da URL da lista de vendedores' do
    user = create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    login_as(user)

    visit users_path

    expect(current_path).to eq dashboard_path
  end

  it 'através da URL de cadastro de vendedores' do
    user = create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    login_as(user)

    visit new_user_path

    expect(current_path).to eq dashboard_path
  end

  it 'através da URL de alteração de cadastro de vendedores' do
    user = create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    user_teste = create(:user, name: 'Usuário 2', email: 'user2@locaweb.com.br', password: '12345678')
    login_as(user)

    visit edit_user_path(user_teste)

    expect(current_path).to eq dashboard_path
  end

  it 'para alterar a senha de outro vendedor' do
    user = create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678')
    user_teste = create(:user, name: 'Usuário 2', email: 'user2@locaweb.com.br', password: '12345678')
    login_as(user)

    visit edit_password_user_path(user_teste)

    expect(current_path).to eq dashboard_path
  end
end
