class Api::V1::OrdersController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_internal_error
  rescue_from ActiveRecord::RecordNotFound, with: :return_not_found
  before_action :find_pending_order, only: %i[cancel awaiting_payment]
  before_action :if_payment_params_is_empty, only: [:pay]
  before_action :if_cancel_reason_param_is_empty, only: [:cancel]

  def list_by_customer
    orders = Order.pending_or_awaiting.where(customer_doc_ident: params[:customer_id])

    return render status: :not_found, json: { response: 'Nenhum registro encontrado' }.to_json if orders.empty?

    render status: :ok, json: orders.as_json(except: %i[id cancel_reason salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def pay
    @order = Order.find_by!(order_code: params[:id], status: :awaiting_payment)

    @order.update!(payment_mode: params[:payment_mode], paid_at: Time.current)
    @order.paid!
    PaidCommission.pay_commission_from_order_code(@order.order_code)
    render status: :ok, json: @order.as_json(except: %i[id cancel_reason salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def discount
    if params[:discount].empty?
      render status: :bad_request,
             json: { error: 'Desconto não informado' }.to_json and return
    end

    @order = Order.find_by!(order_code: params[:id], status: :pending)

    @order.update!(discount: params[:discount])

    render status: :ok, json: @order.as_json(except: %i[id cancel_reason salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def cancel
    @order.update!(status: :cancelled, cancel_reason: params[:cancel_reason])

    render status: :ok, json: @order.as_json(except: %i[id salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def awaiting_payment
    @order.update!(status: :awaiting_payment)

    render status: :ok, json: @order.as_json(except: %i[id salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def renew
    order = Order.find_by(order_code: params[:id], status: :paid)
    return render status: :not_found, json: { response: 'Nenhum registro encontrado' }.to_json if order.nil?

    renewed_order = order.renew_order

    render status: :ok, json: renewed_order.as_json(except: %i[id salesman_id],
                                                    include: { salesman: { only: %i[name email] } })
  rescue ArgumentError => e
    render status: :bad_request, json: { error: e.message }
  rescue StandardError => e
    render status: :internal_server_error, json: { error: e.message }
  end

  private

  def if_payment_params_is_empty
    return if params[:payment_mode].present?

    render status: :bad_request, json: { error: 'Modo de pagamento não informado' }.to_json
  end

  def if_cancel_reason_param_is_empty
    return if params[:cancel_reason].present?

    render status: :bad_request, json: { error: 'Motivo do cancelamento não informado' }.to_json
  end

  def find_pending_order
    @order = Order.find_by!(order_code: params[:id], status: :pending)
  end

  def return_internal_error
    render status: :internal_server_error, json: { error: 'Ocorreu um erro interno' }.to_json
  end

  def return_not_found
    render status: :not_found, json: { response: 'Nenhum registro encontrado' }.to_json
  end
end
