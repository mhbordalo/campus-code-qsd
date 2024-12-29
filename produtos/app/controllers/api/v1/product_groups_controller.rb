module Api
  module V1
    class ProductGroupsController < Api::V1::ApiController
      def index
        product_groups = ProductGroup.active
        render status: :ok, json: product_groups.as_json(except: %i[created_at updated_at])
      end
    end
  end
end
