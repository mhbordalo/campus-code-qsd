require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe '#valid?' do
    context 'presente' do
      it 'falha quando o nome estiver vazio' do
        plan = Plan.new(name: '')
        plan.valid?
        expect(plan.errors[:name]).to include('não pode ficar em branco')
      end

      it 'falha quando o status estiver vazio' do
        plan = Plan.new(status: '')
        plan.valid?
        expect(plan.errors[:status]).to include('não pode ficar em branco')
      end

      it 'falha quando a descrição estiver vazia' do
        plan = Plan.new(description: '')
        plan.valid?
        expect(plan.errors[:description]).to include('não pode ficar em branco')
      end

      it 'falha quando os detalhes estiver vazio' do
        plan = Plan.new(details: '')
        plan.valid?
        expect(plan.errors[:details]).to include('não pode ficar em branco')
      end
    end
  end

  describe '#activate_deactivate_prices' do
    it 'desativa os preços ao desativar o plano' do
      plan = create(:plan)
      periodicity_a = create(:periodicity)
      create(:price, plan:, periodicity: periodicity_a)
      periodicity_b = create(:periodicity, name: 'Anual')
      create(:price, price: 10.0, plan:, periodicity: periodicity_b)

      plan.discontinued!

      Price.where(plan:).each { |pr| expect(pr.inactive?).to be true }
    end

    it 'desativa os preços de um único plano' do
      plan_a = create(:plan)
      product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem de Site', code: 'HOSPE',
                                             status: :active)
      plan_b = create(:plan, name: 'Initial 25', status: :active, description: '25 contas de e-mail', product_group:,
                             details: '15 GB de espaço por conta de e-mail, A partir de R$ 1,30 por conta de e-mail')
      periodicity_a = create(:periodicity)
      periodicity_b = create(:periodicity, name: 'Anual')
      create(:price, plan: plan_a, periodicity: periodicity_a)
      create(:price, price: 10.0, plan: plan_a, periodicity: periodicity_b)
      create(:price, price: 10.0, plan: plan_b, periodicity: periodicity_a)

      plan_a.discontinued!

      Price.where(plan: plan_a).each { |pr| expect(pr.inactive?).to be true }
      Price.where(plan: plan_b).each { |pr| expect(pr.active?).to be true }
    end

    it 'ativa o plano e os preços continuam desativados' do
      plan = create(:plan)
      periodicity_a = create(:periodicity)
      create(:price, plan:, periodicity: periodicity_a)
      periodicity_b = create(:periodicity, name: 'Anual')
      create(:price, price: 10.0, plan:, periodicity: periodicity_b)

      plan.discontinued!
      plan.active!

      Price.where(plan:).each { |pr| expect(pr.inactive?).to be true }
    end
  end
end
