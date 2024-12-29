require 'rails_helper'

RSpec.describe PaidCommission, type: :model do
  describe '#pay_comission_from_order_code' do
    include ActiveSupport::Testing::TimeHelpers

    it 'should create a record with the right commission(bonus extra)' do
      travel_to(Time.new(2023, 3, 5, 14, 35, 0, '+00:00')) do
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF1020')

        salesman = create(:user)

        order = create(:order, price: 150.00, paid_at: 1.day.from_now, discount: 50.00, salesman:)

        bonus_especial = BonusCommission.create({ description: 'Bonus Especial', start_date: Date.current,
                                                  end_date: 2.days.from_now, commission_perc: '5', amount_limit: 100 })

        PaidCommission.pay_commission_from_order_code('ABCDEF1020')

        comissions = PaidCommission.all

        expect(comissions.count).to eq(1)
        expect(comissions[0].amount).to eq((150 - 50) * 0.05)
        expect(comissions[0].paid_at.to_s).to eq('2023-03-05 14:35:00 UTC')
        expect(comissions[0].salesman).to eq(salesman)
        expect(comissions[0].order).to eq(order)
        expect(comissions[0].bonus_commission).to eq(bonus_especial)
      end
    end

    it 'tests the cap limit for bonuses' do
      travel_to(Time.new(2023, 3, 5, 14, 35, 0, '+00:00')) do
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF1020')

        salesman = create(:user)

        order = create(:order, price: 15_000.00, paid_at: 1.day.from_now, salesman:)

        bonus_especial = BonusCommission.create({ description: 'Bonus Especial', start_date: Date.current,
                                                  end_date: 2.days.from_now, commission_perc: 5, amount_limit: 100 })

        PaidCommission.pay_commission_from_order_code('ABCDEF1020')

        comissions = PaidCommission.all

        expect(comissions.count).to eq(1)
        expect(comissions[0].amount).to eq(100)
        expect(comissions[0].paid_at.to_s).to eq('2023-03-05 14:35:00 UTC')
        expect(comissions[0].salesman).to eq(salesman)
        expect(comissions[0].order).to eq(order)
        expect(comissions[0].bonus_commission).to eq(bonus_especial)
      end
    end

    it 'should create a record with the right commission - BASE commision' do
      travel_to(Time.new(2023, 3, 5, 14, 35, 0, '+00:00')) do
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF1020')

        salesman = create(:user)

        order = create(:order, price: 150.00, paid_at: '2023-05-04', discount: 50.00, salesman:)

        BonusCommission.create({ description: 'Bonus Especial', start_date: '2023-03-01',
                                 end_date: '2023-03-05', commission_perc: '5', amount_limit: 100 })

        PaidCommission.pay_commission_from_order_code('ABCDEF1020')

        comissions = PaidCommission.all

        expect(comissions.count).to eq(1)
        expect(comissions[0].amount).to eq((150 - 50) * 0.01)
        expect(comissions[0].paid_at.to_s).to eq('2023-03-05 14:35:00 UTC')
        expect(comissions[0].salesman).to eq(salesman)
        expect(comissions[0].order).to eq(order)
        expect(comissions[0].bonus_commission).to eq(nil)
      end
    end

    it 'should create a record with the BASE commission if there are no commissions in the DB' do
      travel_to(Time.new(2023, 3, 5, 14, 35, 0, '+00:00')) do
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF1020')

        salesman = create(:user)

        order = create(:order, price: 150.00, paid_at: '2023-05-04', discount: 50.00, salesman:)

        PaidCommission.pay_commission_from_order_code('ABCDEF1020')

        comissions = PaidCommission.all

        expect(comissions.count).to eq(1)
        expect(comissions[0].amount).to eq((150 - 50) * 0.01)
        expect(comissions[0].paid_at.to_s).to eq('2023-03-05 14:35:00 UTC')
        expect(comissions[0].salesman).to eq(salesman)
        expect(comissions[0].order).to eq(order)
        expect(comissions[0].bonus_commission).to eq(nil)
      end
    end

    it 'should raise exception for invalid order code' do
      expect { PaidCommission.pay_commission_from_order_code('XYZ') }.to raise_error(StandardError)
    end
  end
end
