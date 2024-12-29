require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid?' do
    it 'Nome não pode ficar em branco' do
      user = User.new(name: '', identification: 12_345_678_900,
                      email: 'brunovulcano@locaweb.com.br', password: '123456')
      user.valid?
      expect(user.errors.include?(:name)).to be true
    end

    it 'Nome deve ser um texto' do
      user = User.new(name: 'Kelsom234 Marcelo', identification: 62_429_965_704,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'SP',
                      zip_code: '22755-170')
      expect(user).not_to be_valid
    end

    it 'Cidate deve ser um texto' do
      user = User.new(name: 'Kelsom Marcelo', identification: 62_429_965_704,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 8897-5959', city: 'Rio2323 Branco', state: 'SP',
                      zip_code: '22755-170')
      expect(user).not_to be_valid
    end

    it 'Estado deve ser um texto' do
      user = User.new(name: 'Kelsom Marcelo', identification: 62_429_965_704,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: '23',
                      zip_code: '22755-170')
      expect(user).not_to be_valid
    end

    it 'Estado deve possuir 2 caracteres' do
      user = User.new(name: 'Kelsom Marcelo', identification: 62_429_965_704,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'Rio de Janeiro',
                      zip_code: '22755-170')
      expect(user).not_to be_valid
    end

    it 'Telefone deve possuir 16 caracteres' do
      user = User.new(name: 'Kelsom Marcelo', identification: 62_429_965_704,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 88975959', city: 'Rio Branco', state: 'RJ',
                      zip_code: '22755-170')
      expect(user).not_to be_valid
    end

    it 'Cep deve possuir 9 caracteres' do
      user = User.new(name: 'Kelsom Marcelo', identification: 62_429_965_704,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'RJ',
                      zip_code: '22755170')
      expect(user).not_to be_valid
    end

    it 'CPF/CNPJ deve possuir 11/16 caracteres' do
      user = User.new(name: 'Kelsom Marcelo', identification: 762_429_965_704,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'RJ',
                      zip_code: '22755-170')
      expect(user).not_to be_valid
    end

    it 'CPF deve ser valido' do
      user = User.new(name: 'Kelsom Marcelo', identification: 62_429_965_704,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'RJ',
                      zip_code: '22755-170')
      expect(user).to be_valid
    end

    it 'CNPJ deve ser valido' do
      user = User.new(name: 'Kelsom Marcelo', identification: 50_567_288_000_310,
                      email: 'brunovulcano@locaweb.com.br', password: '123456',
                      phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'RJ',
                      zip_code: '22755-170')
      expect(user).to be_valid
    end

    it 'CPF não pode ficar em branco' do
      user = User.new(name: 'Bruno Vulcano', identification: '',
                      email: 'brunovulcano@locaweb.com.br', password: '123456')
      user.valid?
      expect(user.errors.include?(:identification)).to be true
    end

    it 'CPF tem que ser um número' do
      user = User.new(name: 'Bruno Vulcano', identification: '1a2345678900',
                      email: 'brunovulcano@locaweb.com.br', password: '123456')
      user.valid?
      expect(user.errors.include?(:identification)).to be true
    end

    it 'CPF tem que ser unico' do
      create(:user, name: 'Kelsom Marcelo', identification: 62_429_965_704,
                    email: 'brunovulcano@locaweb.com.br', password: '123456',
                    phone_number: '(21) 9 8897-5959', city: 'Rio Branco', state: 'SP',
                    zip_code: '22755-170')
      vulcano = User.new(name: 'Vulcano', identification: 62_429_965_704,
                         email: 'vulcano@locaweb.com.br', password: '123456')
      vulcano.valid?
      expect(vulcano.errors.include?(:identification)).to be true
    end
  end
end
