require 'rails_helper'

RSpec.describe Price, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'quando preço está vazio' do
        price = Price.new(price: '')
        price.valid?
        expect(price.errors[:price]).to include('não pode ficar em branco')
      end
    end

    context 'numericality' do
      it 'ok quando preço for positivo' do
        price = Price.new(price: 1)
        price.valid?
        expect(price.errors.include?(:price)).to be false
      end

      it 'quando preço for zero' do
        price = Price.new(price: 0)
        price.valid?
        expect(price.errors[:price]).to include('deve ser maior que 0')
      end

      it 'quando preço for negativo' do
        price = Price.new(price: -1)
        price.valid?
        expect(price.errors[:price]).to include('deve ser maior que 0')
      end
    end
  end
end
