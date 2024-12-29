require 'rails_helper'

RSpec.describe User, type: :model do
  context '#tipo de usuário' do
    it 'usuário padrao' do
      user = create(:user)

      expect(user.user_type_regular?).to eq true
    end
  end
end
