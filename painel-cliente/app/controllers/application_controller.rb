class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    current_user.client? ? orders_path : calls_path
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name identification
                                                         address zip_code
                                                         city state phone_number
                                                         birthdate corporate_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name identification
                                                                address zip_code
                                                                city state phone_number
                                                                birthdate corporate_name])
  end
end
