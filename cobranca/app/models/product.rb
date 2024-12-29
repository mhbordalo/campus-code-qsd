class Product
  attr_accessor :code

  def initialize(code)
    @code = code
  end

  def self.all
    response = Faraday.get('http://localhost:4000/api/v1/product_groups/')

    json = JSON.parse(response.body, symbolize_names: true)
    products = []
    json.map do |item|
      products << new(item[:code])
    end
    products
  end
end
