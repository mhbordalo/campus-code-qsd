require 'rails_helper'

RSpec.describe ProductGroup, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'quando name está vazio' do
        product_group = ProductGroup.new(name: '')
        product_group.valid?
        expect(product_group.errors[:name]).to include('não pode ficar em branco')
      end

      it 'quando description está vazio' do
        product_group = ProductGroup.new(description: '')
        product_group.valid?
        expect(product_group.errors[:description]).to include('não pode ficar em branco')
      end

      it 'quando code está vazio' do
        product_group = ProductGroup.new(code: '')
        product_group.valid?
        expect(product_group.errors[:code]).to include('não pode ficar em branco')
      end

      it 'quando status está vazio' do
        product_group = ProductGroup.new(status: '')
        product_group.valid?
        expect(product_group.errors[:status]).to include('não pode ficar em branco')
      end
    end

    context 'uniquess' do
      it 'code deve ser único' do
        product_group_a = ProductGroup.create!(name: 'Hospedagem', description: 'Hospedagem sites', code: 'HOSPE')
        product_group_b = ProductGroup.new(name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
        product_group_b.save!
        expect(product_group_b.code).not_to eq product_group_a.code
      end
    end

    context 'length' do
      it 'code deve ter no máximo 5 caracteres' do
        product_group = ProductGroup.new(code: 'PROPRO')
        product_group.valid?
        expect(product_group.errors[:code]).to include('é muito longo (máximo: 5 caracteres)')
      end
    end
  end

  describe 'deactivate_plans_and_pricing_for_product_group' do
    it 'ao desativar o grupo de produtos deve desativar os planos e os preços' do
      product_group = create(:product_group)
      plan = create(:plan, product_group:)
      periodicity_b = create(:periodicity)
      periodicity_a = create(:periodicity, name: 'Mensal', deadline: 1)
      periodicity_c = create(:periodicity, name: 'Anual', deadline: 12)
      create(:price, price: 38.97, plan:, periodicity: periodicity_a, status: :active)
      create(:price, price: 119.88, plan:, periodicity: periodicity_b, status: :active)
      create(:price, price: 59.97, plan:, periodicity: periodicity_c, status: :active)

      product_group.inactive!

      plans = Plan.where(product_group:)
      prices = Price.where(plans:)
      plans.each { |pl| expect(pl.discontinued?).to be true }
      prices.each { |pr| expect(pr.inactive?).to be true }
    end

    it 'deve desativar os planos e os preços de um único grupo de produtos' do
      product_group = create(:product_group)
      plan = create(:plan, product_group:)
      periodicity_b = create(:periodicity)
      periodicity_a = create(:periodicity, name: 'Mensal', deadline: 1)
      periodicity_c = create(:periodicity, name: 'Anual', deadline: 12)
      create(:price, price: 38.97, plan:, periodicity: periodicity_a, status: :active)
      create(:price, price: 119.88, plan:, periodicity: periodicity_b, status: :active)
      create(:price, price: 59.97, plan:, periodicity: periodicity_c, status: :active)
      product_group_b = create(:product_group, name: 'E-mail Locaweb', code: 'EMAIL',
                                               description: 'Tenha um e-mail profissional e passe mais credibilidade')
      plan_b = create(:plan, name: 'Initial 25', status: :active, description: '25 contas de e-mail',
                             product_group: product_group_b,
                             details: '15 GB de espaço por conta de e-mail, A partir de R$ 1,30 por conta de e-mail')
      create(:price, price: 38.97, plan: plan_b, periodicity: periodicity_a, status: :active)
      create(:price, price: 119.88, plan: plan_b, periodicity: periodicity_b, status: :active)
      create(:price, price: 59.97, plan: plan_b, periodicity: periodicity_c, status: :active)

      product_group.inactive!

      plans_a = Plan.where(product_group:)
      prices_a = Price.where(plans: plans_a)
      plans_a.each { |pl| expect(pl.discontinued?).to be true }
      prices_a.each { |pr| expect(pr.inactive?).to be true }
      plans_b = Plan.where(product_group: product_group_b)
      prices_b = Price.where(plans: plan_b)
      plans_b.each { |pl| expect(pl.active?).to be true }
      prices_b.each { |pr| expect(pr.active?).to be true }
    end

    it 'ao reativar o grupo de produtos os planos e preços devem permanecer inativos' do
      product_group = create(:product_group)
      plan = create(:plan, product_group:)
      periodicity_b = create(:periodicity)
      periodicity_a = create(:periodicity, name: 'Mensal', deadline: 1)
      periodicity_c = create(:periodicity, name: 'Anual', deadline: 12)
      create(:price, price: 38.97, plan:, periodicity: periodicity_a, status: :active)
      create(:price, price: 119.88, plan:, periodicity: periodicity_b, status: :active)
      create(:price, price: 59.97, plan:, periodicity: periodicity_c, status: :active)

      product_group.inactive!
      product_group.active!

      plans = Plan.where(product_group:)
      prices = Price.where(plans:)
      plans.each { |pl| expect(pl.discontinued?).to be true }
      prices.each { |pr| expect(pr.inactive?).to be true }
    end
  end
end
