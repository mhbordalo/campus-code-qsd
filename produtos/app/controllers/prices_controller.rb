class PricesController < ApplicationController
  before_action :set_price, only: %i[show edit update]
  def index
    @prices = Price.in_order_of(:status, %w[active inactive])
  end

  def show; end

  def new
    @price = Price.new
    @plans = Plan.all
    @periodicities = Periodicity.all
  end

  def edit
    @plans = Plan.all
    @periodicities = Periodicity.all
  end

  def create
    @price = Price.new(price_params)
    inactive_existing_price
    if @price.save
      redirect_to prices_path, notice: t('messages.price.register.success')
    else
      flash.now[:alert] = t('messages.price.register.fail')
      @plans = Plan.all
      @periodicities = Periodicity.all
      render 'new'
    end
  end

  def update
    if @price.update(price_params)
      redirect_to prices_path, notice: t('messages.price.update.success')
    else
      flash.now[:alert] = t('messages.price.update.fail')
      @plans = Plan.all
      @periodicities = Periodicity.all
      render :edit
    end
  end

  private

  def set_price
    @price = Price.find(params[:id])
  end

  def price_params
    params.require(:price).permit(:price, :plan_id, :periodicity_id, :status)
  end

  def inactive_existing_price
    price_exists = Price.find_by(plan: @price.plan.id, periodicity: @price.periodicity.id)
    price_exists.inactive! if price_exists.present?
  end
end
