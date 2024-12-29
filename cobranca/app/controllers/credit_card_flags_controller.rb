class CreditCardFlagsController < ApplicationController
  before_action :set_credit_card_flag, only: %i[show edit update deactivated activated]

  def index
    @credit_card_flags = CreditCardFlag.all
  end

  def show; end

  def new
    @credit_card_flag = CreditCardFlag.new
  end

  def edit; end

  def create
    @credit_card_flag = CreditCardFlag.new(credit_card_flag_params)
    if @credit_card_flag.save
      flash[:notice] = t(:success_flag_created)
      redirect_to @credit_card_flag
    else
      flash.now[:alert] = 'Bandeira não cadastrada.'
      render :new
    end
  end

  def update
    if @credit_card_flag.update(credit_card_flag_params)
      flash[:notice] = t(:success_flag_updated)
      redirect_to credit_card_flag_path(@credit_card_flag.id)
    else
      flash.now[:alert] = 'Não foi possível atualizar a bandeira de cartão de crédito.'
      render :edit
    end
  end

  def deactivated
    @credit_card_flag.deactivated!
    redirect_to @credit_card_flag
  end

  def activated
    @credit_card_flag.activated!
    redirect_to @credit_card_flag
  end

  private

  def set_credit_card_flag
    @credit_card_flag = CreditCardFlag.find(params[:id])
  end

  def credit_card_flag_params
    params.require(:credit_card_flag).permit(:name, :rate, :maximum_value, :maximum_number_of_installments,
                                             :cash_purchase_discount, :status, :picture)
  end
end
