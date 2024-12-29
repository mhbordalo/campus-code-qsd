require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        user = User.new(name: '', email: 'name@locaweb.com.br', password: 'password')

        # Act

        # Assert
        expect(user).not_to be_valid
        expect(user.errors.include?(:name)).to be true
      end
    end

    context 'values' do
      it 'false when domain is not valid' do
        # Arrange
        user = User.new(name: 'Name', email: 'name@gmail.com', password: 'password')

        # Act

        # Assert
        expect(user).not_to be_valid
        expect(user.errors.include?(:email)).to be true
        expect(user.errors.messages[:email][0]).to eq('não pertence a um domínio válido')
      end
    end
    context 'status' do
      it 'false when active is false' do
        # Arrange
        user = User.new(name: 'Name', email: 'name@gmail.com', password: 'password')
        user.active = false

        # Act

        # Assert
        expect(user).not_to be_valid
        expect(user.active_for_authentication?).to be false
      end
    end
  end
end
