require 'rails_helper'

describe 'ator não logado requisita telas de servidor' do
  it 'lista de itens' do
    get(servers_path)

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'formulário de registro' do
    post(servers_path, params: {})

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'detalhes de item' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    server = create(:server, operational_system: :windows, os_version: '10.3.7',
                             number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                             product_group:, type_of_storage: :ssd)

    get(server_path(server.id))

    expect(response).to redirect_to(new_user_session_path)
  end

  it 'formulário de edição' do
    product_group = create(:product_group, name: 'Hospedagem', description: 'Hospedagem sites', code: 'HPPRO')
    server = create(:server, operational_system: :windows, os_version: '10.3.7',
                             number_of_cpus: 32, storage_capacity: 2048, amount_of_ram: 32, max_installations: 50,
                             product_group:, type_of_storage: :ssd)

    patch(server_path(server.id), params: { server: { product_group: } })

    expect(response).to redirect_to(new_user_session_path)
  end
end
