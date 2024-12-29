module Api
  module V1
    class UsersController < ActionController::API
      before_action :users_params, only: %i[create]

      def show
        client = User.find_by(identification: params[:identification])
        if client.nil?
          render status: :not_found, json: client
        else
          render status: :ok, json: client
        end
      end

      def create
        user = User.new(users_params)
        user.password = user.identification
        if user.save
          render status: :ok, json: user
        else
          render status: :bad_request, json: { errors: user.errors.full_messages }
        end
      rescue ActiveRecord::ActiveRecordError
        render status: :internal_server_error, json: {}
      end

      def users_params
        params.require(:user).permit(:email, :password, :identification, :address, :zip_code,
                                     :city, :state, :phone_number, :birthdate,
                                     :name, :corporate_name)
      end
    end
  end
end
