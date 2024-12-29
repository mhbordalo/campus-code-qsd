class ProductService
  BASE_URL = Rails.configuration.external_apis['products_api_url']
  class << self
    def list_product_group
      response = Faraday.get "#{BASE_URL}/product_groups"
      return ResponseHelper.error('Não foi possível acessar a API de grupos de produto') if response.status != 200

      products = JSON.parse(response.body, symbolize_names: true).map do |prod|
        { id: prod[:id], name: prod[:name], description: prod[:description] }
      end
      ResponseHelper.success(products)
    rescue StandardError => e
      ResponseHelper.error(e.message)
    end

    def list_plans(group_id)
      response = Faraday.get "#{BASE_URL}/product_groups/#{group_id}/plans"
      return ResponseHelper.error('Não foi possível acessar a API de planos') if response.status != 200

      plans = JSON.parse(response.body).map do |prod|
        { id: prod['id'], name: prod['name'], description: prod['description'], details: prod['details'] }
      end
      ResponseHelper.success(plans)
    rescue StandardError => e
      ResponseHelper.error(e.message)
    end

    def list_prices(plan_id)
      response = Faraday.get "#{BASE_URL}/plans/#{plan_id}/prices"
      return ResponseHelper.error('Não foi possível acessar a API de preços') if response.status != 200

      prices = JSON.parse(response.body).map do |prod|
        { id: prod['id'], price: prod['price'], plan: prod['plan']['name'],
          periodicity: prod['periodicity']['name'] }
      end
      ResponseHelper.success(prices)
    rescue StandardError => e
      ResponseHelper.error(e.message)
    end
  end
end
