require 'rails_helper'

RSpec.describe InstallProduct, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'quando documento do cliente está vazio' do
        install_product = InstallProduct.new(customer_document: '')
        install_product.valid?
        expect(install_product.errors[:customer_document]).to include('não pode ficar em branco')
      end

      it 'quando código do pedido está vazio' do
        install_product = InstallProduct.new(order_code: '')
        install_product.valid?
        expect(install_product.errors[:order_code]).to include('não pode ficar em branco')
      end
    end
  end
end
