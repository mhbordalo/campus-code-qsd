module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return500
      rescue_from ActiveRecord::RecordNotFound, with: :return404

      private

      def return500
        render json: { error: 'Erro Interno' }, status: :internal_server_error
      end

      def return404
        render json: { error: 'Registro não encontrado' }, status: :not_found
      end
    end
  end
end
