require 'rails_helper'

module Test
  class CPFValidatable
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :cpf

    validates :cpf, cpf: true
  end
end

describe CpfValidator do
  context 'inválido' do
    it 'com número repetido' do
      validatable = Test::CPFValidatable.new(cpf: '00000000000')
      expect(validatable.valid?).to be(false)
    end

    it 'com primeiro dígito inválido' do
      validatable = Test::CPFValidatable.new(cpf: '14138173368')
      expect(validatable.valid?).to be(false)
    end

    it 'com segundo dígito inválido' do
      validatable = Test::CPFValidatable.new(cpf: '14138173357')
      expect(validatable.valid?).to be(false)
    end

    it 'sem números' do
      validatable = Test::CPFValidatable.new(cpf: 'abcdefghijk')
      expect(validatable.valid?).to be(false)
    end

    it 'sem valor' do
      validatable = Test::CPFValidatable.new(cpf: '')
      expect(validatable.valid?).to be(false)
    end

    it 'com nil' do
      validatable = Test::CPFValidatable.new(cpf: nil)
      expect(validatable.valid?).to be(false)
    end
  end

  context 'válido' do
    it 'com número real' do
      validatable = Test::CPFValidatable.new(cpf: '14138173358')
      expect(validatable.valid?).to be(true)
    end
  end
end
