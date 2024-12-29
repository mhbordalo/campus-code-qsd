require 'rails_helper'

RSpec.describe Call, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso se o código do chamado estiver vazio' do
        call = Call.new(call_code: '')

        result = call.valid?

        expect(result).to eq(false)
      end

      it 'falso se o assunto estiver vazio' do
        call = Call.new(subject: '')

        result = call.valid?

        expect(result).to eq(false)
      end

      it 'falso se o descrição estiver vazio' do
        call = Call.new(description: '')

        result = call.valid?

        expect(result).to eq(false)
      end

      it 'falso se o status estiver vazio' do
        call = Call.new(status: '')

        result = call.valid?

        expect(result).to eq(false)
      end
    end

    context 'único' do
      it 'falso se o código do chamado ja existe' do
        user = create(:user, identification: 23_318_591_084, role: :client)
        category = create(:call_category, description: 'Financeiro')
        product = create(:product, user:, order_code: 'ABC123', product_plan_name: 'Plano Hospedagem I')

        allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

        create(:call, subject: 'Host com configurado incorretamente',
                      description: 'O host está com nome de domínio errado',
                      status: :open,
                      user_id: user.id,
                      product_id: product.id,
                      call_category_id: category.id)

        allow(SecureRandom).to receive(:alphanumeric).and_return('XYZ123')

        call = Call.new(subject: 'Host com configurado incorretamente',
                        description: 'O host está com nome de domínio errado',
                        status: :open,
                        user_id: user.id,
                        product_id: product.id,
                        call_category_id: category.id)

        result = call.valid?

        expect(result).to eq(false)
      end
    end
  end
end
