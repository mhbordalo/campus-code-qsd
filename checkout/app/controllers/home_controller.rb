class HomeController < ApplicationController
  def index
    redirect_to new_user_session_path if signed_in?.blank?
    redirect_to dashboard_path if user_signed_in?
  end
end
