module Api
  module V1
    class PlansController < Api::V1::ApiController
      def index
        product_group = ProductGroup.find(params[:product_group_id])
        render status: :ok, json: product_group.plans.active.as_json(except: %i[created_at updated_at])
      end

      def show
        plan = Plan.find(params[:id])
        render status: :ok, json: plan.as_json(except: %i[created_at updated_at])
      end
    end
  end
end
