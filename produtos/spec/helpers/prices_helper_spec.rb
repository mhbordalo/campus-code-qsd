require 'rails_helper'

RSpec.describe PricesHelper, type: :helper do
  describe '#price_status' do
    it 'must call a price_status helper method and show active' do
      grupo = create(:product_group)
      plan = create(:plan, product_group: grupo, status: :active)
      periodicity = create(:periodicity)
      price = create(:price, price: 7.99, plan:, periodicity:, status: :active)
      msg = I18n.t("activerecord.attributes.price.statuses.#{price.status}")

      expect(price_status(price.status, msg)).to include('Ativo')
      expect(price_status(price.status, msg)).to include('ls-tag-primary')
    end

    it 'must call a plan_status helper method and show inactive' do
      grupo = create(:product_group)
      plan = create(:plan, product_group: grupo, status: :active)
      periodicity = create(:periodicity)
      price = create(:price, price: 7.99, plan:, periodicity:, status: :inactive)
      msg = I18n.t("activerecord.attributes.price.statuses.#{price.status}")

      expect(price_status(price.status, msg)).to include('Inativo')
      expect(price_status(price.status, msg)).to include('ls-tag-warning')
    end
  end
end
