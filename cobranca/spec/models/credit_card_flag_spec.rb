require 'rails_helper'

RSpec.describe CreditCardFlag, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'falso quando nome está vazio' do
        flag = CreditCardFlag.new(name: '', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                                  cash_purchase_discount: 'T', status: :activated)
        expect(flag).not_to be_valid
      end
      it 'falso quando taxa está vazio' do
        flag = CreditCardFlag.new(name: 'VISA', rate: '', maximum_value: 1_000, maximum_number_of_installments: 6,
                                  cash_purchase_discount: 'T', status: :activated)
        expect(flag).not_to be_valid
      end
      it 'falso quando valor máximo está vazio' do
        flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: '', maximum_number_of_installments: 6,
                                  cash_purchase_discount: 'T', status: :activated)
        expect(flag).not_to be_valid
      end
      it 'falso quando número máximo de parcelas está vazio' do
        flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: '',
                                  cash_purchase_discount: 'T', status: :activated)
        expect(flag).not_to be_valid
      end
    end
    context 'others validations' do
      it 'falso quando taxa não é número inteiro' do
        flag = CreditCardFlag.new(name: 'VISA', rate: 'A', maximum_value: 1_000, maximum_number_of_installments: 6,
                                  cash_purchase_discount: true, status: :activated)
        expect(flag).not_to be_valid
      end
      it 'falso quando valor máximo não é número inteiro' do
        flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 100.25, maximum_number_of_installments: 6,
                                  cash_purchase_discount: true, status: :activated)
        expect(flag).not_to be_valid
      end
      it 'falso quando número máximo de parcelas não é número inteiro' do
        flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 'T',
                                  cash_purchase_discount: true, status: :activated)
        expect(flag).not_to be_valid
      end
      it 'falso quando taxa não é número inteiro negativo' do
        flag = CreditCardFlag.new(name: 'VISA', rate: -5, maximum_value: 1_000, maximum_number_of_installments: 6,
                                  cash_purchase_discount: true, status: :activated)
        expect(flag).not_to be_valid
      end
      it 'verdadeiro quando taxa é igual a zero' do
        flag = CreditCardFlag.new(name: 'VISA', rate: 0, maximum_value: 1_000, maximum_number_of_installments: 6,
                                  cash_purchase_discount: true, status: :activated)
        expect(flag).to be_valid
      end
      it 'verdadeiro quando taxa é inteiro maior do que zero' do
        flag = CreditCardFlag.new(name: 'VISA', rate: 5, maximum_value: 1_000, maximum_number_of_installments: 6,
                                  cash_purchase_discount: true, status: :activated)
        expect(flag).to be_valid
      end
      it 'quando o desconto não for especificado será false por padrão' do
        flag = CreditCardFlag.new(name: 'VISA', rate: 4, maximum_value: 1_000, maximum_number_of_installments: 6,
                                  cash_purchase_discount: nil, status: :activated)
        expect(flag).to be_valid
        expect(flag.cash_purchase_discount).to eq false
      end
    end
  end
end
