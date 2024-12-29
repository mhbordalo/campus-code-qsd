require 'rails_helper'

RSpec.describe PlansHelper, type: :helper do
  describe '#plan_status' do
    it 'must call a plan_status helper method and show active' do
      grupo = create(:product_group)
      plan = create(:plan, product_group: grupo, status: :active)
      msg = I18n.t("activerecord.attributes.plan.statuses.#{plan.status}")

      expect(plan_status(plan.status, msg)).to include('Ativo')
      expect(plan_status(plan.status, msg)).to include('ls-tag-primary')
    end

    it 'must call a plan_status helper method and show discontinued' do
      grupo = create(:product_group)
      plan = create(:plan, product_group: grupo, status: :discontinued)
      msg = I18n.t("activerecord.attributes.plan.statuses.#{plan.status}")

      expect(plan_status(plan.status, msg)).to include('Descontinuado')
      expect(plan_status(plan.status, msg)).to include('ls-tag-warning')
    end
  end
end
