require 'rails_helper'
require 'cpf_cnpj'

RSpec.describe CreationOrder, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'falso quando CPF/CNPJ não informado' do
        creation_order = CreationOrder.new(customer_identification: '')
        creation_order.current_step = 'customer'

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_identification)).to be true
      end

      it 'falso quando CPF/CNPJ não informado' do
        creation_order = CreationOrder.new(customer_identification: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_identification)).to be true
      end

      it 'falso quando nome não informado' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_name: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_name)).to be true
      end

      it 'falso quando endereço não informado' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_address: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_address)).to be true
      end

      it 'falso quando cidade não informado' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_city: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_city)).to be true
      end

      it 'falso quando estado não informado' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_state: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_state)).to be true
      end

      it 'falso quando cep não informado' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_zipcode: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_zipcode)).to be true
      end

      it 'falso quando email não informado' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_email: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_email)).to be true
      end

      it 'falso quando telefone não informado' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_phone: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_phone)).to be true
      end

      it 'falso quando data de nascimento não informado' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_birthdate: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_birthdate)).to be true
      end

      it 'falso quando nome corporativo não informado' do
        creation_order = CreationOrder.new(customer_identification: '36358603000107', customer_corporate_name: '')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:customer_corporate_name)).to be true
      end

      it 'falso quando produto não informado' do
        creation_order = CreationOrder.new(product_group_form: '')
        creation_order.current_step = 'products'
        creation_order.no_error_found = true

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:product_group_form)).to be true
      end

      it 'falso quando plano não informado' do
        creation_order = CreationOrder.new(product_plan_form: '')
        creation_order.current_step = 'plans'
        creation_order.no_error_found = true

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:product_plan_form)).to be true
      end

      it 'falso quando pacote não informado' do
        creation_order = CreationOrder.new(product_price_form: '')
        creation_order.current_step = 'prices'
        creation_order.no_error_found = true

        expect(creation_order).not_to be_valid
        expect(creation_order.errors.include?(:product_price_form)).to be true
      end
    end

    context 'values' do
      it 'falso quando CEP não está no formato correto' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_zipcode: '11111000')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors[:customer_zipcode]).to eq ['deve estar no formato "99999-999"']
      end

      it 'falso quando telefone não está no formato correto' do
        creation_order = CreationOrder.new(customer_identification: '87591438786', customer_phone: '11 999998888')
        creation_order.current_step = 'customer_data'
        creation_order.customer_exists = false

        expect(creation_order).not_to be_valid
        expect(creation_order.errors[:customer_phone]).to eq [
          'deve estar no formato "(99) 99999-9999" ou "(99) 9999-9999"'
        ]
      end
    end
  end
end
