class BlocklistedCustomersController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: %i[index save destroy]

  def index
    query_doc_ident = params[:search_doc_ident]
    @blocklisted_customers = BlocklistedCustomer.all

    return if query_doc_ident.blank?

    customer_blocklisted = customer_check_blocklist(query_doc_ident)
    if customer_blocklisted.present?
      @blocklisted_customers = [customer_blocklisted]
      @is_blocklisted = true
    end
    @customer = process_customer_from_api(query_doc_ident)
  end

  def save
    BlocklistedCustomer.create!({ doc_ident: params[:id], blocklisted_reason: params[:blocklisted_reason] })
    redirect_to blocklisted_customers_path, notice: I18n.t('blocklisted_customer.msg_customer_blocked')
  rescue ActiveRecord::RecordInvalid
    redirect_to blocklisted_customers_path, alert: I18n.t('blocklisted_customer.msg_customer_block_fail')
  end

  def destroy
    customer_id = params[:id]
    customer = BlocklistedCustomer.find(customer_id)
    customer.destroy!
    redirect_to blocklisted_customers_path, notice: I18n.t('blocklisted_customer.msg_customer_unblocked')
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to blocklisted_customers_path, alert: I18n.t('blocklisted_customer.msg_customer_unblock_fail')
  end

  private

  def redirect_unless_admin
    return if current_user.try(:admin?)

    redirect_to root_path
  end

  def customer_check_blocklist(doc_ident)
    BlocklistedCustomer.find_by(doc_ident:)
  end

  def process_customer_from_api(query_doc_ident)
    customer_data_from_api = CustomerService.get_customer(query_doc_ident)

    if customer_data_from_api[:status] == 'NOT_FOUND'
      flash.now[:alert] = customer_data_from_api[:status_message] and return
    end
    if customer_data_from_api[:status] == 'ERROR_API'
      flash.now[:alert] = I18n.t('blocklisted_customer.msg_customer_api_error') and return
    end

    customer_data_from_api[:data]
  end
end
