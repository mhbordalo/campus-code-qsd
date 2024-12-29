class PaymentService
  BASE_URL = Rails.configuration.external_apis['payments_api_url']
  class << self
    def validate_coupon(coupon_data)
      response = Faraday.get("#{BASE_URL}/coupons/validate", coupon_data)

      return ResponseHelper.not_found('Cupom de desconto inexistente') if response.status == 404
      return ResponseHelper.not_found('Cupom de desconto inválido para esta compra') if response.status == 204
      return ResponseHelper.error('Não foi possível validar este cupom por erro na API') if response.status != 200

      coupon = JSON.parse(response.body, symbolize_names: true)
      ResponseHelper.success(convert_coupon_data(coupon))
    rescue StandardError => e
      ResponseHelper.error(e.message)
    end

    def burn_coupon(coupon_data)
      response = Faraday.post("#{BASE_URL}/coupons",
                              coupon_data.to_json, { 'Content-Type' => 'application/json' })

      return ResponseHelper.not_found('Cupom inexistente') if response.status == 404
      return ResponseHelper.error('Não foi possível confirmar uso do cupom por erro na API') if response.status != 200

      coupon = JSON.parse(response.body, symbolize_names: true)
      ResponseHelper.success(convert_coupon_data(coupon))
    rescue StandardError => e
      ResponseHelper.error(e.message)
    end

    private

    def convert_coupon_data(coupon)
      { coupon_code: coupon[:coupon_code],
        discount: coupon[:discount],
        price: coupon[:price],
        final_price: coupon[:final_price] }
    end
  end
end
