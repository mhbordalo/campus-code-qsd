module Api
  module V1
    class CreditCardsController < Api::V1::ApiController
      def create
        credit_card_params = params.require(:credit_card).permit(:card_number, :validate_month, :validate_year, :cvv,
                                                                 :owner_name, :owner_doc, :credit_card_flag_id)
        credit_card = CreditCard.new(credit_card_params)
        if credit_card.save
          render status: :created, json: credit_card.to_json
        else
          render status: :precondition_failed, json: { errors: credit_card.errors.full_messages }
        end
      end
    end
  end
end
