require 'rails_helper'

describe 'Administrador inicia a criação de uma campanha de bonus,' do
  context 'estando logado como vendedor' do
    it 'e não consegue acessar a página' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)

      visit root_path
      login_as(salesman)

      expect(page).not_to have_content 'Campanha de bonificação'
    end
  end
  context 'estando logado como administrador,' do
    it 'sem sucesso' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      login_as(admin)
      visit bonus_commissions_path
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: ''
      fill_in 'Data de início', with: ''
      fill_in 'Data fim', with: ''
      fill_in 'Percentual de comissão', with: ''
      fill_in 'Limite de comissão', with: ''
      click_on 'Salvar'

      expect(page).to have_content 'Campanha não cadastrada'
      expect(page).to have_content 'Percentual de comissão não pode ficar em branco'
      expect(page).to have_content 'Nome da campanha de bonificação não pode ficar em branco'
      expect(page).to have_content 'Data de início não pode ficar em branco'
      expect(page).to have_content 'Data fim não pode ficar em branco'
      expect(page).to have_content 'Percentual de comissão não pode ficar em branco'
    end
    it 'com sucesso' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      login_as(admin)
      visit bonus_commissions_path
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: 'Hospedagem GO'
      fill_in 'Data de início', with: Date.current
      fill_in 'Data fim', with: 10.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'Limite de comissão', with: 100
      click_on 'Salvar'

      expect(page).to have_content "Hospedagem GO #{I18n.l(Date.current.to_date)}"
      expect(page).to have_content "#{I18n.l(10.days.from_now.to_date)} 10,00% R$ 100,00"
    end
  end
  context 'digitando uma data de' do
    it 'início anterior à atual, tendo erro' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      login_as(admin)
      visit bonus_commissions_path
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: 'Hospedagem GO'
      fill_in 'Data de início', with: 1.day.ago
      fill_in 'Data fim', with: 10.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'Limite de comissão', with: 100
      click_on 'Salvar'

      expect(page).to have_content 'Campanha não cadastrada'
      expect(page).to have_content "Data de início deve ser maior ou igual a #{I18n.l(Date.current.to_date)}"
    end
    it 'fim anterior à data de início, tendo erro' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)

      login_as(admin)
      visit bonus_commissions_path
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: 'Hospedagem GO'
      fill_in 'Data de início', with: 10.days.from_now
      fill_in 'Data fim', with: 9.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'Limite de comissão', with: 100
      click_on 'Salvar'

      expect(page).to have_content 'Campanha não cadastrada'
      expect(page).to have_content "Data fim deve ser maior que #{I18n.l(10.days.from_now.to_date)}"
    end
    it 'início dentro de um intervalo de campanha já cadastrado' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
      BonusCommission.create({ description: 'Bonus Especial 01', start_date: Date.current,
                               end_date: 2.days.from_now, commission_perc: '5', amount_limit: 100 })
      BonusCommission.create({ description: 'Bonus Especial 02', start_date: 3.days.from_now,
                               end_date: 5.days.from_now, commission_perc: '7', amount_limit: 100 })

      login_as(admin)
      visit bonus_commissions_path
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: 'Bonus Especial 02'
      fill_in 'Data de início', with: 4.days.from_now
      fill_in 'Data fim', with: 6.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'Limite de comissão', with: 100
      click_on 'Salvar'

      expect(page).to have_content 'Campanha não cadastrada'
      expect(page).to have_content 'Data de início deve estar fora do intervalo de uma campanha ativa'
    end
    it 'fim dentro de um intervalo de campanha já cadastrado' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
      BonusCommission.create({ description: 'Bonus Especial 01', start_date: 2.days.from_now,
                               end_date: 5.days.from_now, commission_perc: '5', amount_limit: 100 })
      BonusCommission.create({ description: 'Bonus Especial 02', start_date: 6.days.from_now,
                               end_date: 8.days.from_now, commission_perc: '7', amount_limit: 100 })

      login_as(admin)
      visit bonus_commissions_path
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: 'Bonus Especial 02'
      fill_in 'Data de início', with: Date.current
      fill_in 'Data fim', with: 7.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'Limite de comissão', with: 100
      click_on 'Salvar'

      expect(page).to have_content 'Campanha não cadastrada'
      expect(page).to have_content 'Data fim deve estar fora do intervalo de uma campanha ativa'
    end
  end
  context 'digitando o intervalo da campanha' do
    it 'com uma outra campanha dentro do intercalo' do
      admin = create(:user, email: 'admin@locaweb.com.br', password: '12345678', admin: true)
      BonusCommission.create({ description: 'Bonus Especial 01', start_date: 2.days.from_now,
                               end_date: 5.days.from_now, commission_perc: '5', amount_limit: 100 })

      login_as(admin)
      visit bonus_commissions_path
      click_on 'Criar nova campanha'
      fill_in 'Nome da campanha de bonificação', with: 'Bonus Especial 02'
      fill_in 'Data de início', with: Date.current
      fill_in 'Data fim', with: 7.days.from_now
      fill_in 'Percentual de comissão', with: 10
      fill_in 'Limite de comissão', with: 100
      click_on 'Salvar'

      expect(page).to have_content 'Campanha não cadastrada'
      expect(page).to have_content 'Intervalo da campanha em cadastro já tem uma campanha ativa'
    end
  end
end
