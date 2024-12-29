class CustomerService
  class << self
    def get_customer(customer_doc_ident)
      response = Faraday.get("#{Rails.configuration.external_apis['customer_api_url']}/#{customer_doc_ident}")

      return ResponseHelper.not_found('Cliente não encontrado') if response.status == 404

      return ResponseHelper.error('Não foi possível acessar a API de clientes') if response.status != 200

      customer = JSON.parse(response.body, symbolize_names: true)
      ResponseHelper.success(convert_customer(customer))
    rescue StandardError => e
      ResponseHelper.error(e.message)
    end

    def save_customer(customer_data)
      response = Faraday.post(Rails.configuration.external_apis['customer_api_url'],
                              customer_data.to_json, { 'Content-Type' => 'application/json' })

      if response.status != 200 && response.status != 201
        return ResponseHelper.error('Não foi possível cadastrar o cliente')
      end

      ResponseHelper.success(JSON.parse(response.body, symbolize_names: true))
    rescue StandardError => e
      ResponseHelper.error(e.message)
    end

    private

    def convert_customer(customer)
      { doc_ident: customer[:doc_ident], name: customer[:name],
        email: customer[:email], address: customer[:address],
        city: customer[:city], state: customer[:state],
        zipcode: customer[:zipcode], phone: customer[:phone],
        birthdate: customer[:birthdate], corporate_name: customer[:corporate_name] }
    end
  end
end
