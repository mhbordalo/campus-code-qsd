module Api
  module V1
    class PeriodicitiesController < Api::V1::ApiController
      def index
        periodicities = Periodicity.all
        render status: :ok, json: periodicities.as_json(except: %i[created_at updated_at])
      end
    end
  end
end
