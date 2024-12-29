require 'rails_helper'

RSpec.describe Promotion, type: :model do
  context '#valid' do
    it 'falso quando nome está vazio' do
      promotion = build(:promotion, name: '')
      expect(promotion.valid?).to be false
    end

    it 'falso quando código está vazio' do
      promotion = build(:promotion, code: '')
      expect(promotion.valid?).to be false
    end

    it 'falso quando usuário que criou está vazio' do
      promotion = build(:promotion, user_create: '')
      expect(promotion.valid?).to be false
    end

    it 'falso quando data de início está vazio' do
      promotion = build(:promotion, start: '')
      expect(promotion.valid?).to be false
    end

    it 'falso quando data de fim está vazio' do
      promotion = build(:promotion, finish: '')
      expect(promotion.valid?).to be false
    end

    it 'falso quando desconto está vazio' do
      promotion = build(:promotion, discount: '')
      expect(promotion.valid?).to be false
    end

    it 'falso quando quantidade de cupons está vazio' do
      promotion = build(:promotion, coupon_quantity: '')
      expect(promotion.valid?).to be false
    end

    it 'falso quando quantidade de cupons for igual a zero' do
      promotion = build(:promotion, coupon_quantity: 0)
      expect(promotion.valid?).to be false
    end

    it 'falso quando quantidade de cupons for negativa a zero' do
      promotion = build(:promotion, coupon_quantity: -1)
      expect(promotion.valid?).to be false
    end

    it 'falso quando a data final for menor que a inicial' do
      promotion = build(:promotion, start: 1.day.from_now, finish: 1.day.ago)
      expect(promotion.valid?).to be false
    end

    it 'falso quando o desconto não é número' do
      promotion = build(:promotion, discount: 'STRING')
      expect(promotion.valid?).to be false
    end

    it 'falso quando o Valor do desconto não é número' do
      promotion = build(:promotion, maximum_discount_value: 'STRING')
      expect(promotion.valid?).to be false
    end
  end
end
