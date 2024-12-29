require 'rails_helper'

RSpec.describe Charge, type: :model do
  context '#Valid' do
    it 'erro sem o cpf do cliente' do
      charge = build(:charge, client_cpf: '')
      expect(charge.errors.include?(:client_cpf)).to be false
    end

    it 'erro sem a ordem de serviço do cliente' do
      charge = build(:charge, order: '')
      expect(charge.errors.include?(:order)).to be false
    end

    it 'erro sem o valor final da cobrança' do
      charge = build(:charge, final_value: '')
      expect(charge.errors.include?(:final_value)).to be false
    end

    it 'erro sem o token do cartão' do
      charge = build(:charge, creditcard_token: '')
      expect(charge.errors.include?(:creditcard_token)).to be false
    end
  end
end
