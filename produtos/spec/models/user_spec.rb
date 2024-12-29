require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'present' do
      it 'falha quando o name estiver vazio' do
        user_test = User.create(name: '', email: 'admim@locaweb.com.br', password: '123456')

        expect(user_test.valid?).to eq false
      end
      it 'falha quando o e-mail estiver vazio' do
        user_test = User.create(name: 'Joaquim', email: '', password: '123456')

        expect(user_test.valid?).to eq false
      end
      it 'falha quando a senha estiver vazia' do
        user_test = User.create(name: 'Joaquim', email: 'joaquim@locaweb.com.br', password: '')

        expect(user_test.valid?).to eq false
      end
      it 'falha quando o e-mail for inválido' do
        user_test = User.new(name: 'Maria', email: 'maria@outrodominio.com.br', password: '123456')

        expect(user_test.valid?).to eq false
      end
      it 'falha quando o e-mail já estiver em uso' do
        create(:user, email: 'joao@locaweb.com.br')
        user_test = User.new(name: 'João', email: 'joao@locaweb.com.br', password: '123456')

        expect(user_test).not_to be_valid
      end
    end
  end
end
