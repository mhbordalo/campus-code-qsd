require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  context '#valid' do
    it 'com todos os dados ok' do
      credit_card = build(:credit_card)

      credit_card.validate
      expect(credit_card.valid?).to eq true
    end
    it 'erro sem o número do cartão' do
      credit_card = build(:credit_card, card_number: '1')

      credit_card.validate
      expect(credit_card.errors[:card_number].length).to eq 1
    end

    it 'e o número do cartão é único' do
      first_credit_card = build(:credit_card)
      first_credit_card.save!
      second_credit_card = build(:credit_card, card_number: '0984098756785456')
      second_credit_card.save!
      expect(second_credit_card.card_number).not_to eq first_credit_card.card_number
    end

    it 'erro sem o mês de validade do cartão' do
      credit_card = build(:credit_card, validate_month: nil)

      credit_card.validate
      expect(credit_card.errors[:validate_month].length).to eq 2
    end

    it 'erro sem o ano de validade do cartão' do
      credit_card = build(:credit_card, validate_year: nil)
      credit_card.validate
      expect(credit_card.errors[:validate_year].length).to eq 3
    end

    it 'erro com validade vencida cartão' do
      credit_card = build(:credit_card, validate_year: Time.zone.now.year - 2001, validate_month: Time.zone.now.month)
      credit_card.validate
      expect(credit_card.errors[:validate_year].length).to eq 1
    end

    it 'erro sem o código de segurança do cartão' do
      credit_card = build(:credit_card, cvv: '')
      credit_card.validate
      expect(credit_card.errors[:cvv].length).to eq 2
    end

    it 'erro sem o nome do titular do cartão' do
      credit_card = build(:credit_card, owner_name: '')
      credit_card.validate
      expect(credit_card.errors[:owner_name].length).to eq 1
    end

    it 'erro sem o CPF do titular do cartão' do
      credit_card = build(:credit_card, owner_doc: '')
      credit_card.validate
      expect(credit_card.errors[:owner_doc].length).to eq 2
    end

    it 'erro CPF do titular do cartão inválido' do
      credit_card = build(:credit_card, owner_doc: '12345678901')
      credit_card.validate
      expect(credit_card.errors[:owner_doc].length).to eq 1
    end
  end
  context 'gera dados automáticos' do
    it 'ao cadastrar um cartão de crédito' do
      credit_card = build(:credit_card)
      credit_card.save!
      expect(credit_card.token).not_to be_empty
      expect(credit_card.alias).not_to be_empty

      expect(credit_card.token.length).to eq 20
      expect(credit_card.alias.length).to eq 4
      expect(credit_card.alias).to eq '3456'
    end

    it 'e com um token único' do
      first_credit_card = build(:credit_card)
      first_credit_card.save!
      second_credit_card = build(:credit_card, card_number: '0984098756785456')
      second_credit_card.save!
      expect(second_credit_card.token).not_to eq first_credit_card.token
    end
  end

  context 'Criptografia' do
    it 'Testando dados criptografados' do
      credit_card = build(:credit_card, card_number: '1234567890123456')
      expect(credit_card.encrypted_attribute?(:card_number)).to eq false

      credit_card.save!

      expect(credit_card.card_number).to eq('1234567890123456')
      expect(credit_card.ciphertext_for(:card_number)).not_to eq credit_card.card_number

      expect(credit_card.encrypted_attribute?(:card_number)).to eq true
      expect(credit_card.encrypted_attribute?(:cvv)).to eq true
      expect(credit_card.encrypted_attribute?(:owner_name)).to eq true
      expect(credit_card.encrypted_attribute?(:validate_month)).to eq true
      expect(credit_card.encrypted_attribute?(:validate_year)).to eq true
    end
  end
end
