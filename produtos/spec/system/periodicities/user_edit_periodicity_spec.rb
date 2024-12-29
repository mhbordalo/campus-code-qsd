require 'rails_helper'

describe 'Usuário edita uma periodicidade' do
  it 'e não esta logado' do
    periodicity = create(:periodicity)

    visit edit_periodicity_path(periodicity)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Usuário não autenticado')
  end

  it 'da lista de periodicidades' do
    create(:periodicity)

    login
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')
    find('.ls-tooltip-top-left').click

    expect(page).to have_field('Nome', with: 'Trimestral')
  end

  it 'com sucesso' do
    create(:periodicity)

    login
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')
    find('.ls-tooltip-top-left').click
    fill_in 'Nome', with: 'Trimestral Plus'
    fill_in 'Prazo', with: '4'
    click_on 'Salvar'

    expect(page).to have_content 'Periodicidade atualizada com sucesso.'
    expect(page).to have_content 'Trimestral Plus'
    expect(page).to have_content '4'
  end

  it 'não preenche os campos obrigatórios' do
    create(:periodicity)

    login
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')
    find('.ls-tooltip-top-left').click
    fill_in 'Nome', with: ''
    fill_in 'Prazo', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível atualizar periodicidade.')
    expect(page).not_to have_content('Periodicidade atualizada com sucesso.')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Prazo não pode ficar em branco')
  end

  it 'e cancela a operação' do
    create(:periodicity)

    login
    visit root_path
    find('nav.ls-menu').click_on('Periodicidades')
    find('.ls-tooltip-top-left').click
    fill_in 'Nome', with: 'Mensal'
    fill_in 'Prazo', with: '1'
    click_on 'Cancelar'

    expect(current_path).to eq periodicities_path
    expect(page).to have_content('Trimestral')
    expect(page).to have_content('3')
  end
end
