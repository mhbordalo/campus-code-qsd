require 'rails_helper'
require 'securerandom'

RSpec.describe Order, type: :model do
  describe '#gen_order_code' do
    it 'should generate code automatically' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF1020')
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = Order.new({
                          product_group_id: 1,
                          product_group_name: 'Hospedagem de Sites',
                          product_plan_id: 1,
                          product_plan_name: 'Hospedagem GO',
                          product_plan_periodicity_id: 1,
                          product_plan_periodicity: 'Mensal',
                          price: 99.00,
                          customer_doc_ident: '22200022201',
                          salesman:
                        })
      order.save!
      expect(order.valid?).to be_truthy
      expect(order.order_code).to eq('ABCDEF1020')
    end
  end
end
