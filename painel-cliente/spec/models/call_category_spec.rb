require 'rails_helper'

RSpec.describe CallCategory, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false if description is empty' do
        cm = CallCategory.new(description: '')

        result = cm.valid?

        expect(result).to eq(false)
      end
    end

    context 'uniqueness' do
      it 'false if description already exist' do
        create(:call_category, description: 'Suporte')

        cm2 = CallCategory.new(description: 'Suporte')

        result = cm2.valid?

        expect(result).to eq(false)
      end
    end
  end
end
