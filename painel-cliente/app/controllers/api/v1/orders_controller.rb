module Api
  module V1
    class OrdersController < ActionController::API
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def charge
        charge_params = params.require(:charge).permit(:approve_transaction_number, :disapproved_code,
                                                       :disapproved_reason, :client_doc, :order_code)

        @product = Product.find_by(order_code: charge_params[:order_code])
        if @product.present?
          url = "#{ENV.fetch('BASE_URL_PRODUCTS')}/install"
          body = { customer_document: charge_params[:client_doc],
                   order_code: @product.order_code,
                   plan_name: @product.product_plan_name }
          headers = { 'Content-Type' => 'application/json' }
          install = Faraday.post(url, body.to_json, headers)
          @install_message = JSON.parse(install.body)
          install_status(install.status)
          head :no_content
        else
          head :not_found, json: '{ error: "Produto não encontrado." }'
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      def install_status(status)
        return unless status == 200

        @product.installed!
        @product.active!
      end
    end
  end
end
