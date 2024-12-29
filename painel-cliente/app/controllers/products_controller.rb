class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :set_product, only: %i[show renew cancel cancel_status]
  before_action :set_products, only: [:index]

  def index
    @products_active = order_by_name(@products.active)
    @products_cancelled = order_by_name(@products.canceled)

    return unless !current_user.administrator? && !current_user.client?

    flash[:alert] = t('you_have_no_permission_to_access_this_page')
    redirect_to root_path
  end

  def cancel
    # product = Product.find(params[:id]) if params[:id].present?
    url = "#{ENV.fetch('BASE_URL_PRODUCTS')}/uninstall"
    params = { customer_document: current_user.identification,
               order_code: @product.order_code,
               plan_name: @product.product_plan_name }.to_json
    headers = { 'Content-Type': 'application/json' }

    response_cancel = Faraday.post(url, params, headers)
    cancel_status(response_cancel.status)
    redirect_to products_path
  end

  def cancel_status(status)
    if status == 200
      @product.canceled!
      @product.uninstalled!
      flash[:notice] = t('product_canceled_success')
    else
      flash[:alert] = t('error_canceling_product')
    end
  end

  def show; end

  def renew
    renew = Faraday.post("#{ENV.fetch('BASE_URL_CHECKOUT')}/orders/#{@product.order_code}/renew")
    renew_message = JSON.parse(renew.body)
    renew_status(renew.status, renew_message)
    redirect_to products_path
  end

  def renew_status(status, renew_message)
    if status == 200
      flash[:notice] = t('renewal_request_sent_successfully')
    elsif status == 404
      flash[:alert] = "Erro ao enviar solicitação de renovação: #{renew_message['response']}"
    else
      flash[:alert] = "Erro ao enviar solicitação de renovação: #{renew_message['error']}"
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_products
    @products = current_user.administrator? ? Product.all : Product.where(user_id: current_user)
  end

  def order_by_name(list)
    list.joins(:user).order(:name)
  end
end
