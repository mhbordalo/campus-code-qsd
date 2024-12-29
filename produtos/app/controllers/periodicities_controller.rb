class PeriodicitiesController < ApplicationController
  before_action :set_periodicity, only: %i[edit update]

  def index
    @periodicities = Periodicity.all
  end

  def new
    @periodicity = Periodicity.new
  end

  def edit; end

  def create
    @periodicity = Periodicity.new(periodicity_params)
    if @periodicity.save
      redirect_to periodicities_path,
                  notice: t('messages.periodicity.register.success')
    else
      flash.now[:alert] =
        t('messages.periodicity.register.fail')
      render 'new'
    end
  end

  def update
    if @periodicity.update(periodicity_params)
      redirect_to periodicities_path,
                  notice: t('messages.periodicity.update.success').to_s
    else
      flash.now[:alert] =
        t('messages.periodicity.update.fail').to_s
      render 'edit'
    end
  end

  private

  def set_periodicity
    @periodicity = Periodicity.find(params[:id])
  end

  def periodicity_params
    params.require(:periodicity).permit(:name, :deadline)
  end
end
