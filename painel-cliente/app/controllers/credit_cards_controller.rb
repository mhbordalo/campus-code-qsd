class CreditCardsController < ApplicationController
  def index; end

  def new
    @errors = []
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def create
    order = params[:order].to_i
    validadados(params)
    return credit_card_invalid if @errors.length.positive?

    response_creditcard = send_new_credit_card(params)
    return credit_card_invalid if response_creditcard.status != 201

    @credcard = prepare_new_credit_card(response_creditcard)
    if @credcard.save
      redirect_to checkout_order_path(id: order), notice: t('new_credit_card')
    else
      flash.now[:alert] = 'Cartão Invalido !!!'
      render :new
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def validadados(params)
    @errors = []
    @errors << 'Bandeira do cartão invalido !!!' if params[:credit_card_flags].to_i.blank?
    valid_number_creditcard
    valid_month
    valid_year
    valid_cvv
    return unless params[:owner_name].length < 4

    @errors << 'Nome impresso no cartão invalido (no minimo 4 caracteres ou mais) !!!'
  end

  def valid_number_creditcard
    if params[:card_number].to_s.length < 16 || params[:card_number].to_s.length > 16
      @errors << 'Numero do Cartão de Credito invalido (são 16 caracteres) !!!'
    end
    number_card = params[:card_number] !~ /\D/
    @errors << 'Numero do Cartão de Credito invalido (somente 16 caracteres numericos) !!!' if number_card == false
  end

  def valid_month
    if (params[:validate_month].to_s.length < 2 || params[:validate_month].to_s.length > 2) ||
       (params[:validate_month].to_i < 1 || params[:validate_month].to_i > 12)
      @errors << 'Mes de Validade invalido (são 2 caracteres / 01 a 12) !!!'
    end
  end

  def valid_year
    if (params[:validate_year].length < 2 || params[:validate_year].length > 2) ||
       (params[:validate_year].to_i < Time.now.strftime('%y').to_i + 1)
      @errors << 'Ano de Validade invalido (são 2 caracteres / e maior que o ano atual) !!!'
    end
  end

  def valid_cvv
    return unless params[:cvv].length < 3 || params[:cvv].length > 3

    @errors << 'Codigo de Segurança invalido (são 3 caracteres) !!!'
  end

  def credit_card_invalid
    flash.now[:alert] = '!!! Cartão Invalido !!!'
    render :new
  end

  def send_new_credit_card(params)
    parametro = {
      card_number: params[:card_number], validate_month: params[:validate_month],
      validate_year: params[:validate_year], cvv: params[:cvv],
      owner_name: params[:owner_name], owner_doc: current_user.identification.to_s,
      credit_card_flag_id: params[:credit_card_flags]
    }

    url = "#{ENV.fetch('BASE_URL_CHARGES')}/credit_cards"
    headers = { 'Content-Type': 'application/json' }
    Faraday.post(url, parametro.to_json, headers)
  end

  def prepare_new_credit_card(response_creditcard)
    credit = JSON.parse(response_creditcard.body)
    CreditCard.new(card_number: credit['alias'],
                   owner_name: credit['owner_name'],
                   credit_card_flag: credit['flag_name'],
                   token: credit['token'],
                   user_id: current_user.id)
  end

  private

  def credit_card_params
    params.require(:credit_card).permit(:token, :card_number, :owner_name, :credit_card_flag,
                                        :owner_doc, :user_id)
  end
end
