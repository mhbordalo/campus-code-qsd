require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#link_to_show' do
    it 'must call a link_to_show helper method' do
      group = create(:product_group)

      expect(link_to_show(group)).to include('href="/product_groups/1"')
      expect(link_to_show(group)).to include('aria-label="Visualizar"')
    end
  end

  describe '#link_to_edit' do
    it 'must call a link_to_edit helper method' do
      group = create(:product_group)

      expect(link_to_edit(edit_product_group_path(group))).to include('href="/product_groups/1/edit"')
      expect(link_to_edit(edit_product_group_path(group))).to include('aria-label="Editar"')
    end
  end

  describe '#btn_new' do
    it 'must call a btn_new helper method' do
      create(:product_group)

      expect(btn_new(new_product_group_path)).to include('href="/product_groups/new"')
      expect(btn_new(new_product_group_path)).to include('Cadastrar novo')
    end
  end
end
