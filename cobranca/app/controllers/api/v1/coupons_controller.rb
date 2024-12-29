module Api
  module V1
    class CouponsController < ActionController::API
      before_action :if_validation_param_is_missed, only: [:validate]
      before_action :load_coupon_and_price, only: %i[validate burn]

      def validate
        product = params[:product_plan_name]
        return unless @coupon.validated?(product)

        discount = @coupon.calculate_discount(product, @price)
        render status: :ok, json: { coupon_code: @coupon.code, discount:, price: @price,
                                    final_price: @price - discount }.to_json
      end

      def burn
        consumption_application = params[:product_plan_name]
        order_code = params[:order_code]

        if update_coupon(@coupon, order_code, consumption_application)

          discount = @coupon.calculate_discount(consumption_application, @price)
          hook_discount_checkout(order_code, discount)
          render status: :ok, json: { code: @coupon.code, price: @price, discount:,
                                      final_price: @price - discount }.to_json
        else
          render status: :not_found, json: { error: 'Cupom inexistente, inválido ou pedido já possui desconto.' }
        end
      end

      private

      def if_validation_param_is_missed
        return if params[:coupon_code].present? && params[:price].present? && params[:product_plan_name]

        render status: :bad_request, json: { error: 'Dados não informados ou incompletos' }
      end

      def load_coupon_and_price
        @coupon = Coupon.find_by!(code: params[:coupon_code])
        @price = params[:price].to_f
      rescue ActiveRecord::RecordNotFound
        render status: :not_found, json: { error: 'Nenhum registro encontrado' }
      end

      def update_coupon(coupon, order_code, consumption_application)
        coupon.validated?(consumption_application) && Coupon.coupons_with_order(order_code).empty? &&
          coupon.update(status: 3, consumption_application:, order_code:, consumption_date: Time.current)
      end

      def hook_discount_checkout(order_code, discount)
        checkout_url = "/api/v1/orders/#{order_code}/discount"
        response = Faraday.post(checkout_url, { discount: }.to_json, { 'Content-Type' => 'application/json' })

        return if response[:status] == 200

        logger.error "ERRO: O desconto de #{discount} não foi gravado no pedido #{order_code}"
      rescue Faraday::ConnectionFailed
        logger.error(
          "ERRO: Falha ao acessar #{checkout_url} para gravar o desconto de #{discount} no pedido #{order_code}"
        )
      end
    end
  end
end
