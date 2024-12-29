class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :set_order, only: %i[show cancel checkout send_checkout calculated_total]

  def index
    @orders = Order.where(customer_doc_ident: current_user.identification)
    # current_user.administrator? ? Order.all(current_user.identification) :
  end

  def show; end

  def cancel
    cancel = Order.cancel(params[:id])
    @cancel_message = JSON.parse(cancel.body)
    cancel_status(cancel.status, current_user)
    redirect_to orders_path
  end

  def cancel_status(status, current_user)
    if status == 200
      @orders = Order.where(customer_doc_ident: current_user.identification)
      flash[:notice] = t('order_successfully_canceled')
    elsif status == 400
      flash[:alert] = "Erro ao cancelar pedido: #{@cancel_message['response']}"
    else
      flash[:alert] = "Erro ao cancelar pedido: #{@cancel_message['error']}"
    end
  end

  def checkout
    @checkout = Checkout.new(creditcard_token: params[:token],
                             client_cpf: @order.customer_doc_ident,
                             order: @order.order_code,
                             final_value: calculated_total,
                             installment: params[:installment])

    @credit_cards = CreditCard.where(user_id: current_user.id)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def send_checkout
    @checkout = Checkout.new(creditcard_token: params[:token],
                             client_cpf: @order.customer_doc_ident,
                             order: @order.order_code,
                             final_value: calculated_total,
                             installment: params[:installment])

    response = Checkout.send(@checkout)
    checkout_feedback(response.status)

    if response.status == 201
      Product.create!(user: current_user, order_code: @order.order_code,
                      salesman: @order.salesman_id, product_plan_name: @order.product_plan_name,
                      product_plan_periodicity: @order.product_plan_periodicity,
                      price: @order.price, payment_mode: @order.payment_mode,
                      purchase_date: Time.zone.today, status: :waiting_payment,
                      installation: :uninstalled, cancel_reason: nil)
    end

    Checkout.inform_checkout(@order.order_code) if response.status == 201
    redirect_to orders_path
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def set_order
    @order = Order.find(id: params[:id], customer_doc_ident: current_user.identification)
  end

  def calculated_total
    @order.price.to_f * (1.00 - (@order.discount.to_f / 100.00))
  end

  def checkout_feedback(code)
    if code == 201
      flash[:notice] = t('charge_request_success')
    else
      flash[:alert] = t('charge_request_failure')
    end
  end
end
