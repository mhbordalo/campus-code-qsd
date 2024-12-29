module Api
  module V1
    class ChargesController < Api::V1::ApiController
      def index
        render status: :method_not_allowed, json: { error: 'informe um código de cobrança.' }
      end

      def show
        charge = Charge.find_by(id: params[:id].to_i)
        if charge.nil?
          render status: :bad_request, json: { error: 'Cobrança não encontrada.' }
        else
          render status: :ok, json: charge
        end
      end

      def create
        charge_params = params.require(:charge).permit(:creditcard_token, :client_cpf, :order, :final_value)
        charge = Charge.new(charge_params)
        if charge.save
          render status: :created, json: { id: charge.id }
        else
          render status: :precondition_failed, json: { errors: charge.errors.full_messages }
        end
      end
    end
  end
end
