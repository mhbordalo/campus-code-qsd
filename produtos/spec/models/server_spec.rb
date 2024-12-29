require 'rails_helper'

RSpec.describe Server, type: :model do
  describe 'gera um codigo' do
    it 'de até 20 caracteres, com codigo do SO e do grupo de produto' do
      product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPP')
      server = create(:server, operational_system: :windows, product_group:, type_of_storage: :ssd)
      result = server.code

      expect(result).not_to be_empty
      expect(result.length).to be <= 20
      expect(result[0..5]).to eq 'WINDO-'
      expect(result[6..9]).to eq 'HPP-'
    end

    it 'de 20 caracteres, caso prefixos tenham tamanho máximo permitido (5 caracteres)' do
      product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
      server = create(:server, operational_system: :windows, product_group:, type_of_storage: :ssd)
      result = server.code

      expect(result).not_to be_empty
      expect(result.length).to be == 20
      expect(result[0..5]).to eq 'WINDO-'
      expect(result[6..11]).to eq 'HPPRO-'
    end

    it 'que seja único' do
      product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
      server_a = create(:server, operational_system: :windows, product_group:, type_of_storage: :ssd)
      server_b = create(:server, operational_system: :windows, product_group:, type_of_storage: :ssd)
      expect(server_b.code).not_to eq server_a.code
    end

    it 'e não deve ser modificado' do
      product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
      server = create(:server, operational_system: :windows, product_group:, type_of_storage: :ssd)
      original_code = server.code

      server.update!(type_of_storage: :hd)

      expect(server.code).to eq(original_code)
    end
  end

  describe '#valid?' do
    context 'presence' do
      it 'quando número de CPUs está vazio' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(number_of_cpus: '', operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:number_of_cpus]).to include('não pode ficar em branco')
      end

      it 'quando quantidade de RAM está vazio' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(amount_of_ram: '', operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:amount_of_ram]).to include('não pode ficar em branco')
      end

      it 'quando capacidade de armazenamento está vazio' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(storage_capacity: '', operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:storage_capacity]).to include('não pode ficar em branco')
      end

      it 'quando máximo de instalações está vazio' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(max_installations: '', operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:max_installations]).to include('não pode ficar em branco')
      end
    end

    context 'numericality' do
      it 'ok quando quantidade de ram for positivo' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(amount_of_ram: 1, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors.include?(:amount_of_ram)).to be false
      end

      it 'quando quantidade de RAM for zero' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(amount_of_ram: 0, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:amount_of_ram]).to include('deve ser maior que 0')
      end

      it 'quando quantidade de RAM for negativa' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(amount_of_ram: -1, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:amount_of_ram]).to include('deve ser maior que 0')
      end

      it 'quando quantidade de RAM não for inteiro' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(amount_of_ram: 1.5, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:amount_of_ram]).to include('não é um número inteiro')
      end

      it 'ok quando número de CPUs for positivo' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(number_of_cpus: 1, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors.include?(:number_of_cpus)).to be false
      end

      it 'quando número de CPUs for zero' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(number_of_cpus: 0, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:number_of_cpus]).to include('deve ser maior que 0')
      end

      it 'quando número de CPUs for negativa' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(number_of_cpus: -1, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:number_of_cpus]).to include('deve ser maior que 0')
      end

      it 'quando número de CPUs não for inteiro' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(number_of_cpus: 1.5, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:number_of_cpus]).to include('não é um número inteiro')
      end

      it 'ok quando capacidade de armazenamento for positivo' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(storage_capacity: 1, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors.include?(:storage_capacity)).to be false
      end

      it 'quando capacidade de armazenamento for zero' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(storage_capacity: 0, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:storage_capacity]).to include('deve ser maior que 0')
      end

      it 'quando capacidade de armazenamento for negativa' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(storage_capacity: -1, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:storage_capacity]).to include('deve ser maior que 0')
      end

      it 'quando capacidade de armazenamento não for inteiro' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(storage_capacity: 1.5, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:storage_capacity]).to include('não é um número inteiro')
      end

      it 'ok quando máximo de instalações for positivo' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(max_installations: 1, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors.include?(:max_installations)).to be false
      end

      it 'quando máximo de instalações for zero' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(max_installations: 0, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:max_installations]).to include('deve ser maior que 0')
      end

      it 'quando máximo de instalações for negativa' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(max_installations: -1, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:max_installations]).to include('deve ser maior que 0')
      end

      it 'quando máximo de instalações não for inteiro' do
        product_group = create(:product_group, code: 'HPP')
        server = Server.new(max_installations: 1.5, operational_system: :windows,
                            product_group:, type_of_storage: :ssd)
        server.valid?
        expect(server.errors[:max_installations]).to include('não é um número inteiro')
      end
    end
  end
end
