module Api
  module V1
    class PricesController < Api::V1::ApiController
      def search
        prices_from_active_plan = Plan.active.find(params['plan_id']).prices
        active_prices = prices_from_active_plan.select(&:active?)
        if active_prices.empty?
          render status: :ok, json: []
        else
          render status: :ok, json: json_response(active_prices)
        end
      end

      private

      def build_hash(price)
        {
          id: price.id,
          price: price.price,
          plan: price.plan,
          periodicity: price.periodicity,
          product_group: price.plan.product_group
        }
      end

      def json_response(prices)
        data_hashes = []
        prices.each do |price|
          data_hashes << build_hash(price).as_json(except: %i[created_at updated_at status])
        end
        data_hashes
      end
    end
  end
end
