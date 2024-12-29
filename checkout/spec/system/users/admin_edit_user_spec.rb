require 'rails_helper'

describe 'Administrador edita um usuário' do
  it 'com sucesso' do
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    user2 = create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    within("tr#user_#{user2.id}") do
      click_on 'Editar'
    end
    fill_in 'Nome', with: 'José da Silva'
    click_on 'Salvar'

    expect(page).to have_content 'Alterado com sucesso'
    expect(page).to have_content 'José da Silva'
  end

  it 'e falha com um domínio inválido' do
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    user2 = create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    within("tr#user_#{user2.id}") do
      click_on 'Editar'
    end
    fill_in 'E-mail', with: 'jsilva@gmail.com'
    click_on 'Salvar'

    expect(page).to have_content 'E-mail não pertence a um domínio válido'
  end

  it 'e falha com campo vazio' do
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    user2 = create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    within("tr#user_#{user2.id}") do
      click_on 'Editar'
    end
    fill_in 'E-mail', with: ''
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e falha se não confirma a senha' do
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    user2 = create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    within("tr#user_#{user2.id}") do
      click_on 'Editar'
    end
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'erq34erwe'
    click_on 'Salvar'

    expect(page).to have_content 'Confirme sua senha não é igual a Senha'
  end

  it 'e falha se e-mail já existir' do
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    user2 = create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    create(:user, name: 'Pedro Santos', email: 'psantos@locaweb.com.br', password: '12345678')
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    within("tr#user_#{user2.id}") do
      click_on 'Editar'
    end
    fill_in 'E-mail', with: 'psantos@locaweb.com.br'
    click_on 'Salvar'

    expect(page).to have_content 'E-mail já está em uso'
  end

  it 'e altera usuário para administrador' do
    user_admin = create(:user, name: 'Usuário Admin', email: 'user@locaweb.com.br', password: '12345678', admin: true)
    create(:user, name: 'José Silva', email: 'jsilva@locaweb.com.br', password: '12345678')
    user3 = create(:user, name: 'Pedro Santos', email: 'psantos@locaweb.com.br', password: '12345678')
    login_as(user_admin)

    visit root_path
    click_on 'Vendedores'
    within("tr#user_#{user3.id}") do
      click_on 'Editar'
    end
    find(:css, '#user_admin').set(true)
    click_on 'Salvar'

    expect(page).to have_content 'Alterado com sucesso'
    within("tr#user_#{user3.id}") do
      expect(page).to have_css '.ls-ico-checkmark'
    end
  end
end
