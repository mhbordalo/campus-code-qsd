require 'rails_helper'

describe 'Administrador altera status de um usuário' do
  it 'bloqueando com sucesso' do
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    user2 = create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    within("tr#user_#{user2.id}") do
      click_on 'Bloquear'
    end

    expect(page).to have_content 'Usuário bloqueado com sucesso'
    within("tr#user_#{user2.id}") do
      expect(page).to have_button 'Desbloquear'
    end
  end

  it 'desbloqueando com sucesso' do
    user_admin = create(:user, name: 'Usuário Teste', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    user2 = create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678', active: false)
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    within("tr#user_#{user2.id}") do
      click_on 'Desbloquear'
    end

    expect(page).to have_content 'Usuário desbloqueado com sucesso'
    within("tr#user_#{user2.id}") do
      expect(page).to have_button 'Bloquear'
    end
  end
end
