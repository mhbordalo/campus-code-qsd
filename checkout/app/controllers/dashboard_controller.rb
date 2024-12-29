class DashboardController < ApplicationController
  include DashboardControllerMethods

  before_action :authenticate_user!

  def show
    @salesmen_list = User.where(active: true)

    check_filter_in_use

    orders_status_data
    orders_products_data
    orders_periodicity_data
    orders_sales_data
  end
end
