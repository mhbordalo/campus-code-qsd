module Api
  module V1
    class ProductsController < ActionController::API
      def uninstalled
        product = Product.find_by(order_code: params[:order_code])
        if product.present?
          product.update(installation: :uninstalled)
          head :no_content
        else
          head :not_found, json: '{ error: "Produto não encontrado." }'
        end
      end
    end
  end
end
