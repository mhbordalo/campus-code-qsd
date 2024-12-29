require 'rails_helper'

RSpec.describe ProductGroupsHelper, type: :helper do
  describe '#product_group_status' do
    it 'must call a product_group_status helper method and show active' do
      group = create(:product_group)
      msg = I18n.t("activerecord.attributes.product_group.statuses.#{group.status}")

      expect(product_group_status(group.status, msg)).to include('Ativo')
      expect(product_group_status(group.status, msg)).to include('ls-tag-primary')
    end

    it 'must call a product_group_status helper method and show inactive' do
      group = create(:product_group, status: :inactive)
      msg = I18n.t("activerecord.attributes.product_group.statuses.#{group.status}")

      expect(product_group_status(group.status, msg)).to include('Inativo')
      expect(product_group_status(group.status, msg)).to include('ls-tag-warning')
    end
  end
end
