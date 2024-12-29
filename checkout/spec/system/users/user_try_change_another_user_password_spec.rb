require 'rails_helper'

describe 'usuário tenta trocar senha de outro usuário' do
  it 'e volta para página inicial' do
    user1 = create(:user, name: 'Usuário Teste1', email: 'user1@locaweb.com.br', password: '12345678')
    user2 = create(:user, name: 'Usuário Teste2', email: 'user2@locaweb.com.br', password: '87654321')
    login_as(user1)

    visit(edit_password_user_path(user2.id))

    expect(current_path).to eq dashboard_path
  end
end
