require 'rails_helper'

describe 'install_product API' do
  context 'POST api/v1/products/install' do
    it 'e cadastra os dados' do
      product_group = create(:product_group, name: 'Hospedagem de Sites', code: 'HOST')
      create(:plan, name: 'Hospedagem Básica', status: :active, description: '1 Site, 3 Contas de e-mails',
                    product_group:, details: '1 usuário FTP, Armazenamento e Transferencia ilimitada')
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
      create(:server, operational_system: :windows, os_version: '10.3.7', number_of_cpus: 32,
                      storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                      product_group:, type_of_storage: :ssd)
      payload = {
        order_code: '123415',
        customer_document: '620.713.365-31',
        plan_name: 'Hospedagem Básica'
      }

      post '/api/v1/products/install', params: payload

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['code']).to eq('WINDO-HOST-ABCD1234')
    end

    it 'cadastra no servidor com maior disponibilidade com todas instalações ativas' do
      product_group = create(:product_group, name: 'Hospedagem de Sites', code: 'HOST')
      create(:plan, name: 'Hospedagem Básica', status: :active, description: '1 Site, 3 Contas de e-mails',
                    product_group:, details: '1 usuário FTP, Armazenamento e Transferencia ilimitada')
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
      server1 = create(:server, operational_system: :windows, os_version: '10.3.7',
                                number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                                product_group:, type_of_storage: :ssd)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('DEFG4567')
      create(:server, operational_system: :linux, os_version: 'Debian 11.6',
                      number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                      product_group:, type_of_storage: :ssd)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123',
                               server: server1)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'DEF456',
                               server: server1)
      payload = {
        order_code: '123415',
        customer_document: '620.713.365-31',
        plan_name: 'Hospedagem Básica'
      }

      post '/api/v1/products/install', params: payload

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['code']).to eq('LINUX-HOST-DEFG4567')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'cadastra no servidor com maior disponibilidade desconsiderando intalações inativas' do
      product_group = create(:product_group, name: 'Hospedagem de Sites', code: 'HOST')
      create(:plan, name: 'Hospedagem Básica', status: :active, product_group:)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1111')
      server1 = create(:server, operational_system: :windows, os_version: '10.3.7',
                                number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                                product_group:, type_of_storage: :ssd)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD2222')
      server2 = create(:server, operational_system: :linux, os_version: 'Debian 11.6',
                                number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                                product_group:, type_of_storage: :ssd)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD3333')
      server3 = create(:server, operational_system: :linux, os_version: 'Debian 11.6',
                                number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                                product_group:, type_of_storage: :ssd)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123', server: server1)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123', server: server1)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123', server: server1)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123', server: server2)
      create(:install_product, customer_document: '001.001.001-01',
                               order_code: 'ABC123', server: server2, status: :inactive)
      create(:install_product, customer_document: '001.001.001-01',
                               order_code: 'ABC123', server: server2, status: :inactive)
      create(:install_product, customer_document: '001.001.001-01',
                               order_code: 'ABC123', server: server2, status: :inactive)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123', server: server3)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123', server: server3)
      create(:install_product, customer_document: '001.001.001-01',
                               order_code: 'ABC123', server: server3, status: :inactive)
      payload = { order_code: '123415', customer_document: '620.713.365-31', plan_name: 'Hospedagem Básica' }

      post '/api/v1/products/install', params: payload

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['code']).to eq('LINUX-HOST-ABCD2222')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'e não há servidores disponíveis' do
      product_group = create(:product_group, name: 'Hospedagem de Sites', code: 'HOST')
      create(:plan, name: 'Hospedagem Básica', status: :active, product_group:)
      server1 = create(:server, operational_system: :windows, os_version: '10.3.7',
                                number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 1,
                                product_group:, type_of_storage: :ssd)
      server2 = create(:server, operational_system: :linux, os_version: 'Debian 11.6',
                                number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 1,
                                product_group:, type_of_storage: :ssd)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123', server: server1)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'DEF456', server: server2)

      payload = { order_code: '123415', customer_document: '620.713.365-31', plan_name: 'Hospedagem Básica' }
      post '/api/v1/products/install', params: payload

      expect(response.status).to eq 412
      expect(response.body).to include 'Não há servidores disponíveis'
    end

    it 'e falha se parametros não estão completos' do
      product_group = create(:product_group, name: 'Hospedagem de Sites', code: 'HOST')
      create(:plan, name: 'Hospedagem Básica', status: :active, product_group:)
      create(:server, operational_system: :windows, os_version: '10.3.7',
                      number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                      product_group:, type_of_storage: :ssd)
      payload = { plan_name: 'Hospedagem Básica' }

      post '/api/v1/products/install', params: payload

      expect(response).to have_http_status :precondition_failed
      expect(response.body).to include 'Identificação do cliente não pode ficar em branco'
      expect(response.body).to include 'Código do pedido não pode ficar em branco'
    end
  end
end
