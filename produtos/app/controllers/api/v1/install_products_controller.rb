module Api
  module V1
    class InstallProductsController < Api::V1::ApiController
      def create
        return render status: :precondition_failed, json: { errors: 'Não há servidores disponíveis' } \
          if Server.greater_availability(api_request_params[:plan_name]).zero?

        install_product = InstallProduct.new(install_product_params)
        return render status: :ok, json: Server.find(install_product.server_id).as_json(only: 'code') \
          if install_product.save

        render status: :precondition_failed, json: { errors: install_product.errors.full_messages }
      end

      def update
        order_code = api_request_params[:order_code]
        install_product = InstallProduct.find_by(order_code:)
        install_product.update(status: :inactive)
        render status: :ok,
               json: install_product.as_json(only: 'status')
      end

      private

      def api_request_params
        params.permit(:customer_document, :order_code, :plan_name)
      end

      def install_product_params
        { customer_document: api_request_params[:customer_document],
          order_code: api_request_params[:order_code],
          server_id: Server.more_available_server(api_request_params[:plan_name]).id }
      end
    end
  end
end
