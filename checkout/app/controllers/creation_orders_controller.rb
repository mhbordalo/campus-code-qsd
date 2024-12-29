class CreationOrdersController < ApplicationController
  include CreationOrdersControllerInitialize
  include CreationOrdersControllerHandleForm
  include CreationOrdersControllerCustomer
  include CreationOrdersControllerBeforeActions
  include CreationOrdersControllerIntegration
  include CreationOrdersControllerCommon

  before_action :authenticate_user!

  def new
    session[:creation_order_params] = {}
    session[:creation_order_step] = nil
    session[:creation_order_no_error_found] = true
    @creation_order = CreationOrder.new(session[:creation_order_params])
    @creation_order.current_step = session[:creation_order_step]
  end

  def create
    initialize_controller
    handle_form_current_step unless params[:back_button]
    control_flow
    before_actions_next_step
    decides_next_view
  end

  private

  def creation_order_params
    params.require(:creation_order).permit(:customer_identification, :customer_name, :customer_address,
                                           :customer_city, :customer_state, :customer_zipcode,
                                           :customer_email, :customer_phone, :customer_birthdate,
                                           :customer_corporate_name, :product_group_form, :product_plan_form,
                                           :product_price_form, :coupon_code)
  end
end
