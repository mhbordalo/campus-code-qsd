module CreationOrdersControllerIntegration
  extend ActiveSupport::Concern

  def create_new_order
    @creation_order.no_error_found = true
    @order = new_order_object

    if @order.valid? && @order.save
      flash[:notice] = [I18n.t('creation_order.msg_order_created')]
      burn_coupon_via_api
    else
      assemble_order_error_message
      @creation_order.no_error_found = false
    end
  end

  # rubocop:disable Metrics/MethodLength
  def new_order_object
    Order.new(customer_doc_ident: @creation_order.customer_identification,
              product_group_id: @creation_order.product_group_id,
              product_group_name: @creation_order.product_group_name,
              product_plan_id: @creation_order.product_plan_id,
              product_plan_name: @creation_order.product_plan_name,
              product_plan_periodicity_id: @creation_order.product_plan_periodicity_id,
              product_plan_periodicity: @creation_order.product_plan_periodicity,
              price: @creation_order.product_plan_price,
              discount: @creation_order.discount,
              coupon_code: (@creation_order.coupon_code == '' ? nil : @creation_order.coupon_code),
              salesman_id: current_user.id)
  end
  # rubocop:enable Metrics/MethodLength

  def assemble_order_error_message
    flash[:alert] = [I18n.t('creation_order.msg_order_not_created')]
    @order.errors.full_messages.each do |msg|
      flash[:alert] << msg
    end
  end

  def burn_coupon_via_api
    return if @creation_order.coupon_code == ''

    @api_result = PaymentService.burn_coupon(burn_coupon_data_payload)

    if @api_result[:status] == 'SUCCESS'
      flash[:notice] << I18n.t('creation_order.msg_burn_coupon_ok')
      return
    end

    revert_coupon_in_order
    assemble_burn_coupon_error_message
  end

  def burn_coupon_data_payload
    { coupon_code: @creation_order.coupon_code,
      order_code: @order.order_code,
      price: @order.price,
      product_plan_name: @order.product_plan_name }
  end

  def revert_coupon_in_order
    @order.discount = 0
    @order.coupon_code = nil

    @order.save
  end

  def assemble_burn_coupon_error_message
    flash[:alert] = [I18n.t('creation_order.msg_burn_coupon_api_error')]
    flash[:alert] << @api_result[:status_message]
  end
end
