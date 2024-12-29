require 'rails_helper'

RSpec.describe Periodicity, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'quando nome está vazio' do
        periodicity = Periodicity.new(name: '')
        periodicity.valid?
        expect(periodicity.errors[:name]).to include('não pode ficar em branco')
      end

      it 'quando prazo está vazio' do
        periodicity = Periodicity.new(deadline: '')
        periodicity.valid?
        expect(periodicity.errors[:deadline]).to include('não pode ficar em branco')
      end
    end

    context 'uniqueness' do
      it 'nome já está em uso' do
        Periodicity.create!(name: 'Trimestral', deadline: 3)
        periodicity = Periodicity.new(name: 'Trimestral')
        periodicity.valid?
        expect(periodicity.errors[:name]).to include('já está em uso')
      end
    end

    context 'numericality' do
      it 'ok quando prazo for positivo' do
        periodicity = Periodicity.new(deadline: 1)
        periodicity.valid?
        expect(periodicity.errors.include?(:deadline)).to be false
      end

      it 'quando prazo for zero' do
        periodicity = Periodicity.new(deadline: 0)
        periodicity.valid?
        expect(periodicity.errors[:deadline]).to include('deve ser maior que 0')
      end

      it 'quando prazo for negativo' do
        periodicity = Periodicity.new(deadline: -1)
        periodicity.valid?
        expect(periodicity.errors[:deadline]).to include('deve ser maior que 0')
      end

      it 'quando prazo não for inteiro' do
        periodicity = Periodicity.new(deadline: 1.5)
        periodicity.valid?
        expect(periodicity.errors[:deadline]).to include('não é um número inteiro')
      end
    end
  end
end
