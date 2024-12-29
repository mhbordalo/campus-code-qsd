require 'rails_helper'

describe 'uninstall_product API' do
  context 'PATCH api/v1/products/uninstall' do
    it 'e inativa a instalação somente do produto no pedido' do
      group = ProductGroup.create!(
        name: 'Hospedagem de Sites',
        description: 'Domínio e SSL grátis',
        code: 'HOST'
      )
      Plan.create(
        name: 'Hospedagem Básica', status: :active,
        description: '1 Site, 3 Contas de e-mails',
        product_group: group,
        details: '1 usuário FTP, Armazenamento e Transferencia ilimitada'
      )
      server = Server.create!(operational_system: :windows, os_version: '10.3.7',
                              number_of_cpus: 32, storage_capacity: 8192, amount_of_ram: 32, max_installations: 50,
                              product_group: group, type_of_storage: :ssd)

      create(:install_product, customer_document: '001.001.001-01', order_code: 'ABC123', server:)
      create(:install_product, customer_document: '001.001.001-01', order_code: 'DEF456', server:)

      payload = {
        order_code: 'ABC123'
      }
      post '/api/v1/products/uninstall', params: payload

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['status']).to eq('inactive')
      expect(InstallProduct.first.status).to eq 'inactive'
      expect(InstallProduct.last.status).to eq 'active'
    end
  end
end
