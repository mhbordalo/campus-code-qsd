class ChargesController < ApplicationController
  before_action :set_charge, only: %i[show aproved reproved]
  def index
    @charges = Charge.pending
  end

  def show
    @operation = params[:operation]
  end

  def reproved
    @charge = Charge.find(params[:id])
    @charge.reasons_id = params[:reason_id]
    sucess = @charge.save
    if sucess
      flash[:notice] = t('reproved_charge')
      @charge.reproved!
    else
      flash[:alert] = t('non_reproved_charge')
    end
    redirect_to charges_path
  end

  def aproved # rubocop:disable Metrics/MethodLength
    @charge.approve_transaction_number = params[:approve_transaction_number]
    sucess = @charge.save
    if sucess
      flash[:notice] = t('aproved_charge')
      @charge.aproved!
      hook_approved_checkout(@charge)
      hook_approved_customer_panel(@charge)
    else
      flash[:alert] = t('non_aproved_charge')
    end
    redirect_to charges_path
  end

  private

  def set_charge
    @reasons = Reason.all
    @charge = Charge.find(params[:id])
  end

  def hook_approved_checkout(charge)
    checkout_url = "http://localhost:3001/api/v1/orders/#{charge.order}/pay"
    response = Faraday.post(checkout_url, { payment_mode: 'credit_card' }.to_json,
                            { 'Content-Type' => 'application/json' })
    return if response[:status] == 200

    logger.error("ERRO: Não foi possível atualizar o modo de pagamento do pedido #{charge.order}")
  rescue Faraday::ConnectionFailed
    logger.error("ERRO: Falha ao acessar #{checkout_url} para gravar o modo de pagamento do pedido #{charge.order}")
  end

  def hook_approved_customer_panel(charge)
    checkout_url = 'http://localhost:3002/api/v1/order/paid'

    payload = payload_customer(charge)

    response = Faraday.post(checkout_url, payload, { 'Content-Type' => 'application/json' })
    return if response[:status] == 201

    logger.error("ERRO: Não foi possível atualizar os dados de pagamento do pedido #{charge.order}")
  rescue Faraday::ConnectionFailed
    logger.error("ERRO: Falha ao acessar #{checkout_url} para gravar os dados de pagamento do pedido #{charge.order}")
  end

  def payload_customer(charge)
    approve_transaction_number, client_doc, order_code = charge.values_at(:approve_transaction_number,
                                                                          :client_cpf, :order)

    { charge: { approve_transaction_number:, disapproved_code: '',
                disapproved_reason: '', client_doc:, order_code: } }.to_json
  end
end
