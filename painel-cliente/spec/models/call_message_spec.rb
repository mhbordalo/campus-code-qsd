require 'rails_helper'

RSpec.describe CallMessage, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso se a messagem estiver vazia' do
        cm = CallMessage.new(message: '')

        result = cm.valid?

        expect(result).to eq(false)
      end
    end
  end
end
